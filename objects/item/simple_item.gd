@tool
class_name SimpleItems
extends Item
## Класс реализации некоторых базовых предметов.
##
## Реализует логику взаимодействия базовых предметов в с [PlayerCharacter].

## Сигнал испускаемый в случае удачного использования.
signal used(user : PlayerCharacter)

## Типы предметов реализуемые классом
enum Type {
	APPLE, ## Яблоко
	ORANGE, ## Опальсик
	CHILI_PEPPER, ## Перец чили
	OLIVE, ## Оливка
	ALARM_POTION, ## Зелье сигнализации. Испускает сигнал при использовании, сигнал должен быть отслежен [param alarm_potion_handler.gd]
	KEY, ## Ключ
	TOKEN14, ## Жетон
	AMULET, ## Амулет
	TELEPORTER_POTION, ## Зелье телепортации
}

## Тип предмета
@export var type : Type = Type.APPLE

## Логики использования на [param user]. Возвщащает [param true] в случае успеха.
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
				pass # просто испускает сигнал used. Этот сигнал должен быть отслежен alarm_potion_handler.gd
			
			Type.KEY:
				user.keys += 1
			
			Type.TOKEN14:
				return false
			
			Type.AMULET:
				user.health -= 9
				user.max_health += 1
				return false
			
			Type.TELEPORTER_POTION: # отложенная телепортация
				if user.is_inside_tree():
					user.get_tree().physics_frame.connect(random_teleport.bind(user, 1000), CONNECT_ONE_SHOT)
					return true
				return false
			
			_:
				return false
		
		used.emit(user)
		return true
	return false

## Может либыть использован.
func can_use_by(user : PlayerCharacter = null) -> bool:
	if user:
		if type == Type.TELEPORTER_POTION: # требует присутствия user в дереве
			if user.is_inside_tree():
				return true
			return false
		
		return type != Type.TOKEN14 # ничего не делает
	return false

## Может ли быть выброшен.
func can_drop(_user : PlayerCharacter = null) -> bool:
	return true

## Может ли быть перенесен в хранилище.
func is_storable() -> bool:
	return type != Type.KEY # ключи не могут быть перенесены в хранилище

## Телепортация [param user] в рандомное направление с целевой дистанцией и поиском столкновений.
## Дистанция [param distance] является целевой, но может быть не достигнута.
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












