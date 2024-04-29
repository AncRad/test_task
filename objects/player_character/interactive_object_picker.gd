extends ShapeCast2D
## Класс 
## Класс логики взаимодействия с интерактивными объектами [InteractiveObject]
##
## Объект класса подразумевается как часть композиции 'Персонаж игрока'. Должен быть
## одним из дочерних элементов [PlayerCharacter].
## [br]Реализует логику поиска интерактивных объектов [InteractiveObject] в пространстве и логику взаимодействия
## персонажа игрока с ними. При использовании объекта испускает сигнал
## [signal PlayerCharacter.hint_interactive_message].
## [br]Для правильной работы должны быть заданы свойтсва [member player].

## Ссылка на родительский объект.
@export var player : PlayerCharacter # переименовать в user


func _ready() -> void:
	add_exception(player)

## Перехват ввода действия [param player_character_use], использвание обнаруженного объекта и испускание сигнала.
func _unhandled_input(event : InputEvent) -> void:
	if player:
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
