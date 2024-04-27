extends Area2D

@export var user : PlayerCharacter


func _on_area_entered(area : Area2D) -> void:
	if user:
		if area is DoorArea:
			var door := area as DoorArea
			if door.is_exterior():
				if door.is_locked(user):
					if door.can_be_unlocked(user):
						if user.unlock_door(door):
							pass # ok
				
				if not door.is_locked(user):
					if door.can_enter(user):
						if user.enter_door(door):
							pass # ok
			
			else:
				if door.can_enter(user):
					if user.enter_door(door):
						pass # ok


