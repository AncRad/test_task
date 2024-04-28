extends MarginContainer

signal choise(choise : bool)


func _on_yes_pressed() -> void:
	hide()
	choise.emit(true)

func _on_no_pressed() -> void:
	hide()
	choise.emit(false)
