class_name PlayerCharacter
extends CharacterBody2D

signal dead
signal stats_changed
signal hint_interactive_message(message : String, time : float)

const SPEED : float = 600.0
const DEFAULT_MAX_HEALTH : int = 10

@export var max_health : int = DEFAULT_MAX_HEALTH:
	set(value):
		value = maxi(value, 0)
		if value != max_health:
			max_health = value
			stats_changed.emit()
			health = health

@export var health : int = max_health:
	set(value):
		value = clamp(value, 0, max_health)
		if value != health:
			health = value
			if health == 0:
				dead.emit()
			stats_changed.emit()

@export var keys : int = 0:
	set(value):
		value = maxi(value, 0)
		if value != keys:
			keys = value
			stats_changed.emit()


func _physics_process(_delta : float) -> void:
	
	var input_vector := Input.get_vector('player_character_move_left', 'player_character_move_right',
			'player_character_move_up', 'player_character_move_down')
	
	velocity = input_vector * SPEED
	move_and_slide()
	
	if input_vector:
		set_direction(input_vector)

func set_direction(direction : Vector2) -> void:
	%Forward.global_rotation = direction.angle()
	
	var anim_tree := $AnimationTree as AnimationTree
	anim_tree['parameters/direction/blend_position'] = direction

func unlock_door(door : DoorArea) -> bool:
	if keys > 0:
		if door.unlock():
			keys -= 1
			return true
	return false

func enter_door(door : DoorArea) -> bool:
	if door.can_enter():
		if door.enter(self):
			return true
	return false
