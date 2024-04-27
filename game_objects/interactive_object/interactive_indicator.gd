extends InteractiveObject

@export var next_color := Color.GREEN
var last_color : Color
@export var hint_switched_message : String


func _use_by(_user = null) -> bool:
	switch()
	return true

func switch(_user = null) -> void:
	if modulate == next_color:
		modulate = last_color
	else:
		last_color = modulate
		modulate = next_color

func get_hint_message() -> String:
	if modulate == next_color:
		if hint_switched_message:
			return hint_switched_message
	return super()
