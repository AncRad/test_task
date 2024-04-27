class_name HUD
extends Control

@export var player : PlayerCharacter:
	set(value):
		if value != player:
			if player:
				player.stats_changed.disconnect(update)
				player.hint_interactive_message.disconnect(hint_interactive_message)
			
			player = value
			
			if player:
				player.stats_changed.connect(update)
				player.hint_interactive_message.connect(hint_interactive_message)
			update()

var _updated := true


func _ready() -> void:
	show()
	update()
	hide_interactive_message()

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

func _update() -> void:
	_updated = true
	if player:
		%LabelHPCount.text = '%d/%d' % [player.health, player.max_health]
		%LabelKeysCount.text = '%d' % player.keys
	else:
		%LabelHPCount.text = '%d/%d' % [0, 0]
		%LabelKeysCount.text = '%d' % 0
		hide_interactive_message()
