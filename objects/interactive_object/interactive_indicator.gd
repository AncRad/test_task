extends InteractiveObject
## @experimental
## Интерактивный индикатор с переключателем.
##
## Это класс для тестирования взаимодействия [InteractiveObject] с 
## [param player_character/interactive_object_picker.gd"]

## Следующий цвет после переключаения
@export var next_color := Color.GREEN
## Следующее сообщение после переключения
@export var hint_switched_message : String
## Предыдущий цвет
var last_color : Color

## Логика использования индикатора - переключения.
func _use_by(_user = null) -> bool:
	switch()
	return true

## Логика переключения. Смена цвета на [param next_color] или [param modulate].
func switch(_user = null) -> void:
	if modulate == next_color:
		modulate = last_color
	else:
		last_color = modulate
		modulate = next_color

## Переопределение логики извлечения текста сообщения.
## Возвращает [param hint_switched_message] если переключен, иначе [member InteractiveObject.get_hint_message()]
func get_hint_message() -> String:
	if modulate == next_color:
		if hint_switched_message:
			return hint_switched_message
	return super()
