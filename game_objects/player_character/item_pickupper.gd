extends Area2D

const PickupableItem = preload("../pickupable_item/pickupable_item.gd")

@export var user : PlayerCharacter


func _on_area_entered(area : Area2D) -> void:
	if user:
		if area is PickupableItem:
			if area.can_pickup():
					var item : Item = area.item
					if item and item.can_use_by(user):
						if area.pickup():
							if not item.use_by(user):
								assert(false)
