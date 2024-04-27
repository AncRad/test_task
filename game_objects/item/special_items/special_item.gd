@tool
class_name SpecialItem
extends Item

signal used(user : PlayerCharacter)


func use_by(user : PlayerCharacter) -> bool:
	if user:
		used.emit(user)
		return true
	return false

func can_use_by(user : PlayerCharacter) -> bool:
	if user and user.is_inside_tree():
		return true
	return false














