class_name Builder
extends Node

#signal map_changed(map : Map)
signal player_changed(player : PlayerCharacter)

@export var main_map_scn : PackedScene
@export var player_scn : PackedScene

var player : PlayerCharacter
var current_map : Map

var _deffered := false
var _maps : Array[Map] = []


func _ready() -> void:
	_build.call_deferred()

func rebuild() -> void:
	assert(not _deffered)
	if not _deffered:
		_deffered = true
		_rebuild.call_deferred()

func add_map(map_scn : PackedScene) -> Map:
	var map := map_scn.instantiate() as Map
	_maps.append(map)
	return map

func change_map(next_map : Map, exit_point : Node2D) -> bool:
	assert(not _deffered)
	assert(next_map in _maps)
	if not _deffered and next_map in _maps:
		_deffered = true
		_change_map.call_deferred(next_map, exit_point)
		return true
	return false

func _rebuild() -> void:
	_deffered = false
	_destruct()
	_build()
	player.hint_interactive_message.emit("Ваш персонаж погиб. Мир перезапущен.")

func _destruct() -> void:
	player_changed.emit(null)
	
	for map in _maps:
		if is_instance_valid(map):
			if map.is_inside_tree():
				remove_child(map)
			map.free()
			assert(not is_instance_valid(map))
	_maps.clear()
	
	assert(not is_instance_valid(player))
	player = null

func _build() -> void:
	player = player_scn.instantiate() as PlayerCharacter
	player.dead.connect(rebuild)
	
	var map = add_map(main_map_scn)
	
	_change_map(map, map.exit_point)
	
	player_changed.emit(player)

func _change_map(next_map : Map, exit_point : Node2D) -> void:
	_deffered = false
	
	if is_instance_valid(current_map):
		if current_map.is_inside_tree():
			remove_child(current_map)
		current_map = null
	
	if player.get_parent():
		player.get_parent().remove_child(player)
	
	assert(not player.get_parent())
	
	current_map = next_map
	next_map.add_child(player)
	add_child(next_map)
	player.global_position = exit_point.global_position
	player.set_direction(exit_point.transform.x)



















