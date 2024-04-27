@tool
extends Area2D

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

var enabled : bool:
	set(value):
		enabled = value
		_update_collision_shapes.call_deferred()


func _enter_tree() -> void:
	update()

func pickup() -> bool:
	if enabled:
		enabled = false
		queue_free()
		return true
	return false

func can_pickup() -> bool:
	return enabled

func _update_collision_shapes() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred(&'disabled', not enabled)

func update() -> void:
	if item:
		%Sprite2D.texture = item.texture
		%Sprite2D.scale = item.get_sprite_scale()
	else:
		%Sprite2D.texture = null
		%Sprite2D.scale = Vector2.ONE
