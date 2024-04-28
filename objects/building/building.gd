@tool
class_name Building
extends Node2D

signal locked_changed(locked : bool)

@export var locked : bool = true:
	set(value):
		locked = value
		locked_changed.emit(locked)

@export var exit_point : Node2D
@export var interier_scn : PackedScene

var builder : Builder
var interior : BuildingMap
var _main_map : Map


func _enter_tree() -> void:
	if Engine.is_editor_hint():
		return
	
	if interier_scn:
		if find_parent("Builder") is Builder:
			builder = find_parent("Builder")
		
		if builder:
			_main_map = builder.current_map
			assert(_main_map)
			
			if not interior:
				interior = builder.add_map(interier_scn) as BuildingMap
				interior.building = self
	
	if not builder or not interior:
		locked = true


func enter(_entering : PlayerCharacter) -> bool:
	if can_enter():
		return builder.change_map(interior, interior.exit_point)
	return false

func can_enter() -> bool:
	return not locked and has_interior()

func has_interior() -> bool:
	if Engine.is_editor_hint():
		return interier_scn != null
	else:
		return builder and interior and interior.exit_point


func exit(_exiting : PlayerCharacter) -> bool:
	if can_exit():
		return builder.change_map(_main_map, exit_point)
	return false

func can_exit() -> bool:
	return builder and _main_map and exit_point


func unlock() -> bool:
	if can_unlock():
		locked = false
		return true
	return false

func is_locked() -> bool:
	return locked

func can_unlock() -> bool:
	return locked and has_interior()












