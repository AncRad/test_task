class_name ExitPoint
extends Node2D

var _character : PlayerCharacter
var _map : Map


func _enter_tree() -> void:
	if _character:
		_put_character.call_deferred()

func put_chacater(character : PlayerCharacter, map : Map) -> void:
	assert(not _character)
	if not _character:
		_character = character
		_map = map
		if is_inside_tree():
			_put_character.call_deferred()

func _put_character() -> void:
	if _character:
		if is_inside_tree():
			if _character.get_parent():
				_character.get_parent().remove_child(_character)
				_map.add_child(_character)
				_character.global_position = global_position
				_character.set_direction(global_transform.x)
				_character = null
				_map = null
