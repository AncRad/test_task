@tool
class_name SimpleItems
extends Item

signal used(user : PlayerCharacter)

enum Type {
	#NULL,
	APPLE,
	ORANGE,
	CHILI_PEPPER,
	OLIVE,
	ALARM_POTION,
	KEY,
	TOKEN14,
	AMULET,
	TELEPORTER_POTION,
}

@export var type : Type = Type.APPLE


func use_by(user : PlayerCharacter = null) -> bool:
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
				pass
			
			Type.KEY:
				user.keys += 1
			
			Type.TOKEN14:
				return false
			
			Type.AMULET:
				user.health -= 9
				user.max_health += 1
				return false
			
			Type.TELEPORTER_POTION:
				if user.is_inside_tree():
					user.get_tree().physics_frame.connect(random_teleport.bind(user, 1000), CONNECT_ONE_SHOT)
					return true
				return false
			
			_:
				return false
		
		used.emit(user)
		return true
	return false

func can_use_by(user : PlayerCharacter = null) -> bool:
	if user:
		if type == Type.TELEPORTER_POTION:
			if user.is_inside_tree():
				return true
			return false
		
		return type != Type.TOKEN14
	return false

func can_drop(_user : PlayerCharacter = null) -> bool:
	return true

func is_storable() -> bool:
	return type != Type.KEY

static func random_teleport(user : PlayerCharacter, distance : float) -> void:
	var motion := Vector2.RIGHT.rotated(randf_range(0,1) * TAU) * distance
	var position := user.global_position
	
	#if false:
		#var vel := user.velocity
		#for i in 50:
			#position = user.global_position
			#user.velocity = motion / user.get_process_delta_time()
			#user.move_and_slide()
			#if user.global_position.distance_to(position) >= distance:
				#print("попыток ", i)
				#break
			#if user.velocity:
				#motion = user.velocity.normalized() * distance
			#else:
				#motion = Vector2.RIGHT.rotated(randf_range(0,1) * TAU) * distance
		#user.velocity = vel
	
	#else:
	var coll := KinematicCollision2D.new()
	for i in 50:
		user.test_move(Transform2D(0, position), motion, coll)
		if user.global_position.distance_to(position) >= distance:
			break
		if coll.get_collider_rid():
			position += coll.get_travel()
			var norm := coll.get_normal()
			var norm_90 := (norm - norm * norm.dot(motion.normalized())).normalized()
			motion = norm_90 * (distance - user.global_position.distance_to(position))
			if coll.get_travel().length() < 5:
				motion = -motion
	
	user.global_position = position
	user.set_direction(motion.normalized())












