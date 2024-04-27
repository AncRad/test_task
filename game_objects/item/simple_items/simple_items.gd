@tool
class_name SimpleItems
extends Item

enum Type {
	#NULL,
	APPLE,
	ORANGE,
	CHILI_PEPPER,
	OLIVE,
	ALARM_POTION,
	KEY,
}

@export var type : Type = Type.APPLE


func use_by(user : PlayerCharacter) -> bool:
	if user:
		match type:
			Type.APPLE:
				user.health += 1
			
			Type.ORANGE:
				user.max_health += 1
				user.health += 1
			
			Type.CHILI_PEPPER:
				user.health -= 1
			
			Type.OLIVE:
				user.max_health -= 10
			
			Type.ALARM_POTION:
				if user.is_inside_tree():
					pass
				else:
					return false
			
			Type.KEY:
				user.keys += 1
		return true
	return false

func can_use_by(user : PlayerCharacter) -> bool:
	if user:
		if type == Type.ALARM_POTION:
			return user.is_inside_tree()
		else:
			return true
	return false

func get_sprite_scale() -> Vector2:
	if sprite_scale.is_finite():
		return sprite_scale
	
	var scales : Dictionary = {
		Type.APPLE : Vector2.ONE,
		Type.ORANGE : Vector2.ONE,
		Type.CHILI_PEPPER : Vector2.ONE,
		Type.OLIVE : Vector2.ONE,
		Type.ALARM_POTION : Vector2.ONE * 0.5,
		Type.KEY : Vector2.ONE * 0.5,
	}
	if type in scales:
		return scales[type]
	return Vector2.ONE














