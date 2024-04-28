@tool
extends "building.gd"

@export var texture_building : Texture:
	set(value):
		texture_building = value
		update()

@export var texture_door_closed : Texture:
	set(value):
		texture_door_closed = value
		update()

@export var texture_door_opened : Texture:
	set(value):
		texture_door_opened = value
		update()


func _ready():
	update()

func update() -> void:
	if get_node_or_null('%SpriteBuilding'):
		%SpriteBuilding.texture = texture_building
	if get_node_or_null('%SpriteDoor'):
		if locked:
			%SpriteDoor.texture = texture_door_closed
		else:
			%SpriteDoor.texture = texture_door_opened
