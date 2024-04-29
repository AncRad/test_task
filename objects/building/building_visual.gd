@tool
extends "building.gd"
## Постройка с визуальной составляющей

## Текстура спрайта
@export var texture_building : Texture:
	set(value):
		texture_building = value
		update()

## Текстура спрайта закрытой двери
@export var texture_door_closed : Texture:
	set(value):
		texture_door_closed = value
		update()

## Текстура спрайта открытой двери
@export var texture_door_opened : Texture:
	set(value):
		texture_door_opened = value
		update()


func _ready():
	update()

## Обновление визуальной составляющей
func update() -> void:
	if get_node_or_null('%SpriteBuilding'):
		%SpriteBuilding.texture = texture_building
	if get_node_or_null('%SpriteDoor'):
		if locked:
			%SpriteDoor.texture = texture_door_closed
		else:
			%SpriteDoor.texture = texture_door_opened
