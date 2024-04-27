extends Area2D

@export var user : PlayerCharacter


func _on_area_entered(area : Area2D) -> void:
	if user:
		if area is DoorArea:
			var door := area as DoorArea
			if door.exterior:
				if door.is_locked():
					if door.can_unlock():
						if user.unlock_door(door):
							pass # ok
				
				if not door.is_locked():
					if door.can_enter():
						if user.enter_door(door):
							pass # ok
			
			else:
				if door.can_enter():
					if user.enter_door(door):
						pass # ok


