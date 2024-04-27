class_name MapHolder
extends Node

signal map_changed(map : Map)

@export var current_map : Map
var _next_map : Map


func change_map(map : Map) -> bool:
	assert(map)
	assert(not map.is_inside_tree())
	assert(not _next_map)
	if not _next_map:
		if map and not map.is_inside_tree():
			if current_map:
				assert(current_map.get_parent() and current_map.get_parent() == self)
				if current_map.get_parent() and current_map.get_parent() == self:
					#current_map.set_deferred(&'process_mode', Node.PROCESS_MODE_DISABLED)
					_next_map = map
					_change_map.call_deferred()
					return true
	return false

func _change_map() -> void:
	if current_map:
		remove_child(current_map)
		current_map.process_mode = Node.PROCESS_MODE_DISABLED
		current_map = null
	
	current_map = _next_map
	_next_map.process_mode = Node.PROCESS_MODE_INHERIT
	add_child(_next_map)
	_next_map = null
	map_changed.emit(current_map)
