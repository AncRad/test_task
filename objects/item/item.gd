@tool
class_name Item # Переименовать ItemType
extends Resource
## Базовый класс реализации типа предметов
##
## Этот класс является классом шаблоном для будущих классов типов предметов.
## Определяет базовые параметры, такие как [param texture], и шаблоны базовых функций взаимодейтствий.

## Текстура, которая может быть использована в качестве [member Sprite2D.texture] в пространстве и иконки в GUI.
@export var texture : Texture:
	set(value):
		texture = value
		emit_changed()

## Размер, который может быть использован в качестве [member Sprite2D.size]
@export var sprite_scale := Vector2.ONE

## Ключи для [Translation] для вывода названия и описания типа предмета.
@export_group('Translation', 'translation_')
## Контекст перевода.
@export var translation_context := &'item'
## Ключ перевода имени типа объекта.
@export var translation_name := &'no_name'
## Ключ перевода описания типа объекта.
@export var translation_description := &'no_description'


## Использовать игроком. По умолчанию возвращает [param false].
func use_by(_user : PlayerCharacter = null) -> bool:
	return false

## Может ли быть использован. По умолчанию возвращает [param false].
func can_use_by(_user : PlayerCharacter = null) -> bool:
	return false

## Может ли быть выброшен. По умолчанию возвращает [param false].
func can_drop(_user : PlayerCharacter = null) -> bool:
	return false

## Можно ли поместить в хранилище. По умолчанию возвращает [param false].
func is_storable() -> bool:
	return false

## Возвращает текстуру. Может быть реализована более сложнаяя логика.
func get_texture() -> Texture:
	return texture

## Возвращает размер спрайта. Может быть реализована более сложнаяя логика.
func get_sprite_scale() -> Vector2:
	return sprite_scale

## Возвращает переведенное имя типа объекта.
func get_visible_name() -> String:
	return tr(translation_name, translation_context)

## Возвращает переведенное описание типа объекта.
func get_visible_description() -> String:
	return tr(translation_description, translation_context)
