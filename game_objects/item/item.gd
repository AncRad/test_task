@tool
class_name Item
extends Resource

@export var texture : Texture:
	set(value):
		texture = value
		emit_changed()

@export var sprite_scale := Vector2(INF, INF):
	set(value):
		sprite_scale = value
		emit_changed()


func use_by(_user : PlayerCharacter) -> bool:
	return false

func can_use_by(_user : PlayerCharacter) -> bool:
	return false

func can_drop_from(_user : PlayerCharacter) -> bool:
	return false

func can_store_by(_user : PlayerCharacter) -> bool:
	return false

#func can_pickup_by(_user : PlayerCharacter) -> bool:
	#return false

func get_texture() -> Texture:
	return texture

func get_sprite_scale() -> Vector2:
	if sprite_scale.is_finite():
		return sprite_scale
	return Vector2.ONE
