class_name HUD
extends Control

@export var player : PlayerCharacter: set = set_player

var _updated := true
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

func _unhandled_input(event : InputEvent) -> void:
	if event.is_pressed() and not event.is_echo():
		if event.is_action("player_character_inventory_toggle"):
			get_viewport().set_input_as_handled()
			%PlayerInventoryPanel.visible = not %PlayerInventoryPanel.visible
	
	if _handle_input and event.is_action_type():
		get_viewport().set_input_as_handled()

func update() -> void:
	if _updated:
		_updated = false
		_update.call_deferred()

func hint_interactive_message(message : String, time : float = 5) -> void:
	if message:
		%PanelInteractiveItemMessage.show()
		%LabelInteractiveItemMessage.text = message
		%TimerInteractiveItemMessage.start(time if time > 0 else 5.0)
	else:
		hide_interactive_message()

func hide_interactive_message() -> void:
	%LabelInteractiveItemMessage.text = ""
	%PanelInteractiveItemMessage.hide()
	%TimerInteractiveItemMessage.stop()

func player_door_open_callback() -> bool:
	get_tree().paused = true
	%DoorAcceptPopup.show()
	var yes : bool = await %DoorAcceptPopup.choise
	get_tree().paused = false
	return yes

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

func _on_inventory_panel_visibility_changed() -> void:
	_handle_input = %PlayerInventoryPanel.visible

func _update() -> void:
	_updated = true
	if player:
		%LabelHPCount.text = '%d/%d' % [player.health, player.max_health]
		%LabelKeysCount.text = '%d' % player.keys
	else:
		%LabelHPCount.text = '%d/%d' % [0, 0]
		%LabelKeysCount.text = '%d' % 0
		hide_interactive_message()

