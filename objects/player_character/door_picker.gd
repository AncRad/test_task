extends Area2D

@export var user : PlayerCharacter


func _on_area_entered(area : Area2D) -> void:
	if user:
		if area is DoorArea:
			var door := area as DoorArea
			var building := door.get_building()
			if building:
				if door.exterior:
					if building.is_locked() and building.can_unlock() and user.can_unlock():
						var yes := true
						if user.door_open_callback:
							yes = await user.door_open_callback.call()
						if yes:
							if user.unlock(building):
								pass # ok
					
					if building.can_enter():
						building.enter(user)
				
				else:
					if building.can_exit():
						building.exit(user)


