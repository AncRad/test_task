@tool
class_name DoorArea
extends Area2D

@export var exterior : bool = true:
	set(value):
		if value != exterior:
			exterior = value
			notify_property_list_changed()
@export var building : Building
@export var building_map : BuildingMap


func _validate_property(property : Dictionary) -> void:
	if property.name in ['building', 'building_map']:
		if exterior:
			if property.name == 'building_map':
				property.usage = PROPERTY_USAGE_NONE
		else:
			if property.name == 'building':
				property.usage = PROPERTY_USAGE_NONE

func get_building() -> Building:
	if exterior:
		return building
	else:
		return building_map.building

func is_locked() -> bool:
	if exterior:
		return get_building().is_locked()
	else:
		return false

func unlock() -> bool:
	if exterior:
		return get_building().unlock()
	return false

func can_unlock() -> bool:
	return get_building().can_unlock()

func can_enter() -> bool:
	if exterior:
		return get_building().can_enter()
	else:
		return get_building().can_exit()

func enter(character : PlayerCharacter) -> bool:
	if can_enter():
		if exterior:
			return get_building().enter(character)
		else:
			return get_building().exit(character)
	return false

