@tool
class_name DoorArea
extends Area2D
## Область входа в дверь для построек [Building]
## 
## Используется как часть композиции [Building] и [BuildingMap], но не ограничивается этим.
## Создает присутствие в физическом пространстве для обнаружения и содержит ссылку на [Building],
## влающеющую дверь.[br]
## Для правильной работы должено быть указано свойтво [member exterior], а также [param building] или
## [param building_map] в завистмости от [param true] или [param false] свойтсова [member exterior],
## соответственно.

## Внешняя дверь, или внутренняя.
@export var exterior : bool = true:
	set(value):
		if value != exterior:
			exterior = value
			notify_property_list_changed()

## Ссылка на экстерьер постройки для логики внешней двери.
@export var building : Building

## Ссылка на карту интерьера для логики внутренней двери.
@export var building_map : BuildingMap

## Настраивает свойства для инспектора.
func _validate_property(property : Dictionary) -> void:
	if property.name in ['building', 'building_map']:
		if exterior:
			if property.name == 'building_map':
				property.usage = PROPERTY_USAGE_NONE
		else:
			if property.name == 'building':
				property.usage = PROPERTY_USAGE_NONE

## Возвращает ссылку на постройку.
func get_building() -> Building:
	if exterior:
		return building
	else:
		return building_map.building
