class_name InteractiveObject
extends CollisionObject2D

@export var hint_message : String = ""
@export_range(0, 10, 0.1, "or_greater", "suffix:секунд")
var hint_time : float = 0


func use_by(user : PlayerCharacter) -> bool:
	if user:
		if _use_by(user):
			return true
	return false

func _use_by(_user : PlayerCharacter) -> bool:
	return true

func get_hint_message() -> String:
	return hint_message

func get_hint_time() -> float:
	return hint_time
