@tool
class_name Building
extends Node2D

signal locked_changed(locked : bool)

@export var locked : bool = true:
	set(value):
		#if value != locked:
			locked = value
			locked_changed.emit(locked)

@export var exit_point : ExitPoint
@export var interier : PackedScene
@export var map_holder : MapHolder


var interior_map : BuildingMap
var _map : Map ## BAD


func _notification(what : int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if is_instance_valid(interior_map):
			interior_map.queue_free() ## BAD

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		return
	
	if not map_holder and not Engine.is_editor_hint():
		if find_parent("MapHolder") is MapHolder:
			map_holder = find_parent("MapHolder")
	
	if map_holder:
		_map = map_holder.current_map
	
	if interier and not interior_map:
		var inst := interier.instantiate() ## BAD
		if inst is BuildingMap:
			interior_map = inst
			interior_map.building = self
	
	if not map_holder or not interior_map:
		locked = true


func enter(entering : PlayerCharacter) -> bool:
	if can_enter():
		if map_holder.change_map(interior_map): ## BAD
			interior_map.exit_point.put_chacater(entering, interior_map)
			return true
	return false

func can_enter() -> bool:
	return not locked and has_interior()

func has_interior() -> bool:
	if Engine.is_editor_hint():
		return interier != null
	else:
		return interior_map and map_holder


func exit(exiting : PlayerCharacter) -> bool:
	if can_exit():
		if map_holder.change_map(_map): ## BAD
			exit_point.put_chacater(exiting, _map)
			return true
	return false

func can_exit() -> bool:
	return map_holder and exit_point


func unlock() -> bool:
	if can_unlock():
		locked = false
		return true
	return false

func is_locked() -> bool:
	return locked

func can_unlock() -> bool:
	return locked and has_interior()












