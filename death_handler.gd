extends Node

@export var map_holder : MapHolder:
	set(value):
		map_holder = value

var _old_map : Node
var _restart : bool = false


func _on_player_character_dead() -> void:
	_restart = true
	%HUD.player = null
	if map_holder.current_map:
		_old_map = map_holder.current_map
	
	var scn := load("res://map_street.tscn") as PackedScene
	map_holder.change_map(scn.instantiate())


func _on_map_holder_map_changed(_map) -> void:
	if _restart:
		_restart = false
		if is_instance_valid(_old_map):
			_old_map.queue_free()
			_old_map = null
		
		var player := map_holder.current_map.get_node("%PlayerCharacter") as PlayerCharacter
		%HUD.player = player
		player.dead.connect(_on_player_character_dead)
		player.hint_interactive_message.emit("Ваш персонаж умер. Мир перезапущен.", 5)
