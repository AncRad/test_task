class_name PlayerCharacter
extends CharacterBody2D

signal dead
signal stats_changed
signal hint_interactive_message(message : String, time : float)

const ObjectPicker = preload('interactive_object_picker.gd')

const SPEED : float = 600.0
const SPEED_FAST : float = SPEED * 2
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


func _ready() -> void:
	%InteractiveObjectPicker.add_exception(self)

func _unhandled_input(event : InputEvent) -> void:
	if event.is_pressed() and not event.is_echo():
		if event.is_action('player_character_use'):
			var picker := %InteractiveObjectPicker as ObjectPicker
			var object := picker.use(self)
			if object and object.get_hint_message():
				hint_interactive_message.emit(object.get_hint_message(), object.get_hint_time())

func _physics_process(_delta : float) -> void:
	
	var input_vector : Vector2
	#var faster : bool
	if get_window().has_focus():
		#faster = Input.is_action_pressed('player_character_move_fast')
		input_vector = Input.get_vector('player_character_move_left', 'player_character_move_right',
				'player_character_move_up', 'player_character_move_down')
	
	#if input_vector:
		#velocity.x = move_toward(velocity.x, input_vector.x * SPEED, SPEED * _delta * 15)
		#velocity.y = move_toward(velocity.y, input_vector.y * SPEED, SPEED * _delta * 15)
	#else:
		#velocity.y = move_toward(velocity.y, 0, SPEED * _delta * 15)
		#velocity.x = move_toward(velocity.x, 0, SPEED * _delta * 15)
	
	#if faster:
		#velocity = input_vector * SPEED_FAST
	#else:
		#velocity = input_vector * SPEED
	
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
		if door.can_be_unlocked(self):
			if door.unlock(self):
				keys -= 1
				return true
	return false

func enter_door(door : DoorArea) -> bool:
	if door.can_enter(self):
		if door.enter(self):
			return true
	return false
