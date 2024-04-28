@tool
class_name Item
extends Resource

@export var texture : Texture:
	set(value):
		texture = value
		emit_changed()

@export var sprite_scale := Vector2.ONE

@export_group('Translation', 'translation_')
@export var translation_context := &'item'
@export var translation_name := &'no_name'
@export var translation_description := &'no_description'


func use_by(_user : PlayerCharacter = null) -> bool:
	return false

func can_use_by(_user : PlayerCharacter = null) -> bool:
	return false

func can_drop(_user : PlayerCharacter = null) -> bool:
	return false

func is_storable() -> bool:
	return false

func get_texture() -> Texture:
	return texture

func get_sprite_scale() -> Vector2:
	return sprite_scale

func get_visible_name() -> String:
	return tr(translation_name, translation_context)

func get_visible_description() -> String:
	return tr(translation_description, translation_context)
