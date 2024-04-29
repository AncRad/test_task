extends ShapeCast2D

@export var player : PlayerCharacter


func _ready() -> void:
	add_exception(player)

func _unhandled_input(event : InputEvent) -> void:
	if event.is_pressed() and not event.is_echo():
		
		if event.is_action('player_character_use'):
			get_viewport().set_input_as_handled()
			var interactive : InteractiveObject
			for collision in collision_result:
				if collision.collider is InteractiveObject:
					interactive = collision.collider
					break
			
			if interactive:
				if interactive.use_by(player):
					if interactive.get_hint_message():
						player.hint_interactive_message.emit(interactive.get_hint_message(),
								interactive.get_hint_time())
