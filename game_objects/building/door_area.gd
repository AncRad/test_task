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
	if is_exterior():
		return building
	else:
		return building_map.get_building()

func is_exterior() -> bool:
	return exterior

func is_locked(_character : PlayerCharacter = null) -> bool:
	if exterior:
		return get_building().is_locked()
	else:
		return false

func can_be_unlocked(character : PlayerCharacter = null) -> bool:
	if is_exterior():
		return get_building().can_be_unlocked(character)
	return false

func unlock(character : PlayerCharacter = null) -> bool:
	if is_exterior():
		if can_be_unlocked(character):
			return get_building().unlock(character)
	return false

func can_enter(character : PlayerCharacter = null) -> bool:
	if is_exterior():
		return get_building().can_enter(character)
	else:
		return get_building().can_exit(character)

func enter(character : PlayerCharacter = null) -> bool:
	if can_enter(character):
		if is_exterior():
			return get_building().enter(character)
		else:
			return get_building().exit(character)
	return false

