@tool
class_name Building
extends Node2D

signal locked_changed(locked : bool)

@export var locked : bool = true:
	set(value):
		#if value != locked:
			locked = value
			locked_changed.emit(locked)

@export var interier : PackedScene
@export var map_holder : MapHolder

var _building_map : BuildingMap
var _map : Map


func _notification(what : int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if is_instance_valid(_building_map):
			_building_map.queue_free()

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		return
	
	if not map_holder:
		var finded := find_parent("MapHolder")
		if finded is Node:
			map_holder = finded as MapHolder
	if map_holder:
		_map = map_holder.get_current_map()
	
	if interier:
		var inst := interier.instantiate()
		if inst is BuildingMap:
			_building_map = inst
			_building_map._building = self
	
	if not map_holder or not _building_map:
		locked = true


func enter(entering : PlayerCharacter) -> bool:
	if can_enter(entering):
		if map_holder.change_map(_building_map):
			var exit_point := _building_map.get_exit_point()
			exit_point.put_chacater(entering, _building_map)
			#enter_request.emit(self, entering)
			return true
	return false

func can_enter(_entering : PlayerCharacter) -> bool:
	return not locked and has_interior()

func has_interior() -> bool:
	if Engine.is_editor_hint():
		return interier != null
	else:
		return _building_map and map_holder


func exit(exiting : PlayerCharacter) -> bool:
	if exiting:
		if can_exit(exiting):
			if map_holder.change_map(_map):
				var exit_point := get_exit_point()
				exit_point.put_chacater(exiting, _map)
				#exit_request.emit(self, exiting)
				return true
	return false

func can_exit(_exiting : PlayerCharacter) -> bool:
	assert(map_holder)
	assert(get_exit_point())
	return has_exterior()

func get_exit_point() -> ExitPoint:
	return %ExitPoint as ExitPoint

func has_exterior() -> bool:
	return map_holder and get_exit_point()


func unlock(_entering : PlayerCharacter) -> bool:
	if can_be_unlocked():
		locked = false
		return true
	return false

func is_locked() -> bool:
	return locked

func can_be_unlocked(_character : PlayerCharacter = null) -> bool:
	return locked and has_interior()













