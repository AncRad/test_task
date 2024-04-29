@tool
class_name PickupableItem # Переименовать в DroppedItem
extends Area2D
## Класс реализации логики поведения брошенных на землю пердметов [Item]
##
## Отображает текстуру объекта [Item], создает присутствие Area2D для обнаружения предмета
## в физическом пространстве.

## Ссылка на тип [Item]
@export var item : Item:
	set(value):
		if value != item:
			if item:
				enabled = false
				item.changed.disconnect(update)
			
			item = value
			
			if item:
				enabled = true
				item.changed.connect(update)
			
			update()

## Отложенно управляет видимостью объекта в физическом пространстве.
var enabled : bool:
	set(value):
		enabled = value
		_update_collision_shapes.call_deferred()


func _ready() -> void:
	update()

## Реализует собственное поведение при подборе, например удаление объекта из мира.
## Возвращает [param true], если все прошло успешно.
func pickup() -> bool:
	if enabled:
		enabled = false
		queue_free()
		return true
	return false

## Может ли быть предмет подобран.
func can_pickup() -> bool:
	return enabled

## Обновление видимости в физическом пространстве, смотри [param enabled]
func _update_collision_shapes() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred(&'disabled', not enabled)

## Обновить визуалюную составляющую в соответствии с [member item]
func update() -> void:
	if item:
		%Sprite2D.texture = item.texture
		%Sprite2D.scale = item.get_sprite_scale()
	else:
		%Sprite2D.texture = null
		%Sprite2D.scale = Vector2.ONE
