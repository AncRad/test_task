class_name ItemPicker
extends Area2D

const PickupableItem = preload("../pickupable_item/pickupable_item.gd")
const PICKUPABLE_ITEM = preload("../pickupable_item/pickupable_item.tscn")

@export var user : PlayerCharacter:
	set(value):
		if value != user:
			if user:
				user.item_picker = null
			
			user = value
			
			if user:
				user.item_picker = self

@export var container : ItemContainer:
	set(value):
		if value != container:
			if container:
				container.changed.disconnect(_on_container_changed)
				_on_container_changed()
			container = value
			
			if container:
				container.changed.connect(_on_container_changed)
				_on_container_changed()

var _area_ignore_once : Array[Area2D] = []


func _on_area_entered(area : Area2D) -> void:
	if area in _area_ignore_once:
		_area_ignore_once.erase(area)
		return
	
	if container:
		if area is PickupableItem:
			var pickupable_item := area as PickupableItem
			if pickupable_item.can_pickup():
				var item : Item = pickupable_item.item
				if item.is_storable() and container.can_append(item):
					if pickupable_item.pickup():
						if not container.append(item):
							assert(false)
				
				elif user and item.can_use_by(user):
					if pickupable_item.pickup():
						if not item.use_by(user):
							assert(false)

func _on_container_changed() -> void:
	if has_node('%CollisionShape2D'):
		if %CollisionShape2D.disabled != not container and container.has_free_space():
			%CollisionShape2D.disabled = not %CollisionShape2D.disabled

func can_use(item : Item) -> bool:
	if item and item.can_use_by(user):
		if item in container.items:
			return true
	return false

func use(item : Item) -> bool:
	if can_use(item):
		if item.use_by(user):
			var ok := container.remove(container.items.find(item))
			assert(ok)
			return true
	return false

func can_drop(item : Item) -> bool:
	if item and item.can_drop(user):
		if item in container.items:
			return true
	return false

func drop(item : Item) -> bool:
	if can_drop(item):
		if container.remove(container.items.find(item)):
			_instantiate_pickupable_item.call_deferred(item, user.get_parent())
			return true
		else:
			assert(false)
	return false

func _instantiate_pickupable_item(item : Item, parent : Node) -> void:
	var pickupable_item := PICKUPABLE_ITEM.instantiate() as PickupableItem
	pickupable_item.item = item
	_area_ignore_once.append(pickupable_item)
	pickupable_item.global_position = global_position
	parent.add_child(pickupable_item)






















