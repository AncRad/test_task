class_name HUD
extends Control
## Класс управленяи графическим интерфейсом персонажа игрока.
##
## Выводит на экран базовые парметры [PlayerCharacter], интерактивные сообщения.
## Обрабатывает выбор запроса подтверждения открытия двери.
## Выводит интерфейс управления инвентаря персонажа игрока.

## Ссылка на обрабатываемого персонажа игрока.
@export var player : PlayerCharacter: set = set_player

## Обновлен ли интерфейс. Используется для отложенного обновления.
var _updated := true

## Будет ли перехватываеть все события ввода. Используется для блокировки ввода, когда отображается
## интерфейс инвентаря. Управляет свойством [member PlayerCharacter.handle_input].
var _handle_input := false:
	set(value):
		_handle_input = value
		if player:
			player.handle_input = not _handle_input


func _ready() -> void:
	show()
	hide_interactive_message()
	%DoorAcceptPopup.hide()
	%PlayerInventoryPanel.hide()
	update()

## Перехват и обработка событий ввода.
func _unhandled_input(event : InputEvent) -> void:
	if event.is_pressed() and not event.is_echo():
		if event.is_action("player_character_inventory_toggle"):
			get_viewport().set_input_as_handled()
			%PlayerInventoryPanel.visible = not %PlayerInventoryPanel.visible
	
	if _handle_input and event.is_action_type():
		get_viewport().set_input_as_handled()

## Отложенный вызов обновления.
func update() -> void:
	if _updated:
		_updated = false
		_update.call_deferred()

## Высвечивает интерактивное сообщение.
func hint_interactive_message(message : String, time : float = 5) -> void:
	if message:
		%PanelInteractiveItemMessage.show()
		%LabelInteractiveItemMessage.text = message
		%TimerInteractiveItemMessage.start(time if time > 0 else 5.0)
	else:
		hide_interactive_message()

## Скрывает интерактивное сообщение.
func hide_interactive_message() -> void:
	%LabelInteractiveItemMessage.text = ""
	%PanelInteractiveItemMessage.hide()
	%TimerInteractiveItemMessage.stop()

## Ожидаемый обратный вызов от [member player] для возвращения подтверждения
## расхода ключа и открытия постройки. Открывает [prarm %DoorAcceptPopup] и
## ставит игру на паузу, пока не получит ответ от окно через [prarm await].
func player_door_open_callback() -> bool:
	get_tree().paused = true
	%DoorAcceptPopup.show()
	var yes : bool = await %DoorAcceptPopup.choise
	get_tree().paused = false
	return yes

## Сеттер [member player].
func set_player(value : PlayerCharacter) -> void:
	if value != player:
		if player:
			player.stats_changed.disconnect(update)
			player.hint_interactive_message.disconnect(hint_interactive_message)
			player.door_open_callback = Callable()
			%PlayerInventoryPanel.player = null
			%PlayerInventoryPanel.hide()
			_handle_input = %PlayerInventoryPanel.visible
		else:
			assert(not %DoorAcceptPopup.visible)
		
		player = value
		
		if player:
			player.stats_changed.connect(update)
			player.hint_interactive_message.connect(hint_interactive_message)
			player.door_open_callback = player_door_open_callback
			%PlayerInventoryPanel.player = player
			%PlayerInventoryPanel.hide()
			_handle_input = %PlayerInventoryPanel.visible
		update()

## Отслеживание изменения видимости панели инвентаря.
## Начинает или останавливает перехват ввода для блокировки управления.
func _on_inventory_panel_visibility_changed() -> void:
	_handle_input = %PlayerInventoryPanel.visible

## Обновление интерфейса вывода. Рекомендуется вместо этого вызывать [member _update]
func _update() -> void:
	_updated = true
	if player:
		%LabelHPCount.text = '%d/%d' % [player.health, player.max_health]
		%LabelKeysCount.text = '%d' % player.keys
	else:
		%LabelHPCount.text = '%d/%d' % [0, 0]
		%LabelKeysCount.text = '%d' % 0
		hide_interactive_message()























