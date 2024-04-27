class_name InteractiveObject
extends CollisionObject2D

#signal used_by(user : PlayerCharacter)
#signal hint(message : String, time : float)

#@export_group("Hint", "hint_")
@export var hint_message : String = ""
@export_range(0, 10, 0.1, "or_greater", "suffix:секунд")
var hint_time : float = 0


func can_use_by(user : PlayerCharacter) -> bool:
	if user:
		return true
	return false

func use_by(user : PlayerCharacter) -> bool:
	if user:
		if _use_by(user):
			#used_by.emit(user)
			#hint.emit(get_hint_message(), hint_time)
			return true
	return false

func _use_by(_user : PlayerCharacter) -> bool:
	return true

func get_hint_message() -> String:
	return hint_message

func get_hint_time() -> float:
	return hint_time
