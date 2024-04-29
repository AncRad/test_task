class_name PlayerCharacter
extends CharacterBody2D
## Класс персонажа игрока
##
## Класс используется для родительского узла композиции 'Персонаж игрока'. Подразумевается
## инкапсуляция дочерних узлов и вывод ссылок на некоторых из них, таких как [ItemContainer],
## [ItemPicker], и событий как [signal dead], [signal stats_changed].
## Реализует захват ввода и перемещение, логику базовых параметров здоровья и ключей.

## Испускается, когда [member health] достигает значения 0.
signal dead
## Испускается, когда изменилось значение основного свойства, как [member keys].
## Полезно для отслеживания изменений графическим интерфейсом.
signal stats_changed
## Используется для вывода сообщения в графический интерфейс, например, при взаимодействии с 
## [InteractiveObject].
signal hint_interactive_message(message : String, time : float)

const SPEED : float = 600.0
const DEFAULT_MAX_HEALTH : int = 10

## Если true, то будет реагировать на ввод [InputEvent].
@export var handle_input := true

## Ограничивает максимальное значение [member health]. Не может быть меньше 0.
## При изменении испускает сигнал [signal stats_changed].
@export var max_health : int = DEFAULT_MAX_HEALTH:
	set(value):
		value = maxi(value, 0)
		if value != max_health:
			max_health = value
			stats_changed.emit()
			health = health

## Счетчик здоровья. Не может быть меньше 0, или больше [member max_health].
## Испускает сигнал [signal dead], когда значение достигает 0.
## При изменении испускает сигнал [signal stats_changed].
@export var health : int = max_health:
	set(value):
		value = clamp(value, 0, max_health)
		if value != health:
			health = value
			if health == 0:
				dead.emit()
			stats_changed.emit()

## Счетчик ключей. Не может быть меньше 0.
## При изменении испускает сигнал [signal stats_changed].
@export var keys : int = 0:
	set(value):
		value = maxi(value, 0)
		if value != keys:
			keys = value
			stats_changed.emit()

## Ссылка на дочерний объект, который является основным хранилищем предметов персонажа игрока.
## Используется для доступа вненешних объектов к хранилищу предметов персонажа. Должен быть задан в инспекторе.
@export var container : ItemContainer

## Обратный вызов для подтверждения открытия двери и использования ключа, фунция должна вернуть [bool]
## true, если дверь можно открыть.
var door_open_callback : Callable

## Ссылка на дочерний объект [ItemPicker] для использования внешними обхектами.
var item_picker : ItemPicker


func _physics_process(_delta : float) -> void:
	
	var input_vector : Vector2
	if handle_input:
		input_vector = Input.get_vector('player_character_move_left', 'player_character_move_right',
				'player_character_move_up', 'player_character_move_down')
	
	velocity = input_vector * SPEED
	move_and_slide()
	
	if input_vector:
		set_direction(input_vector)

## Устанавливает анимацию в соответстви и с направлением. Вращает внутренни узел Forward.
func set_direction(direction : Vector2) -> void:
	%Forward.global_rotation = direction.angle()
	
	var anim_tree := $AnimationTree as AnimationTree
	anim_tree['parameters/direction/blend_position'] = direction

## Открывает здание [param building], если здание может быть открыто,
## и если есть здания ([member can_unlock()] == true)
func unlock(building : Building) -> bool:
	if keys > 0:
		if building.unlock():
			keys -= 1
			return true
	return false

## Возвращает true, если есть возможность открывать здания.
func can_unlock() -> bool:
	return keys > 0
