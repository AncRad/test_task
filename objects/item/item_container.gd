class_name ItemContainer
extends Node

signal changed

@export_range(0, 20, 1)
var max_items : int = 10:
	set(value):
		if value != max_items:
			if value < 0 and value != items.size() or value < items.size():
				assert(false)
				return
			max_items = value
			emit_changed_deferred()

@export
var items : Array[Item] = []:
	set(value):
		var while_protect := 10000
		while null in value and while_protect:
			value.erase(null)
			while_protect -= 1
		assert(while_protect)
		items = value
		emit_changed_deferred()

var _emit_changed_requested := false


func can_append(item : Item) -> bool:
	return item and items.size() < max_items

func append(item : Item) -> bool:
	if can_append(item):
		items.append(item)
		emit_changed_deferred()
		return true
	return false

func remove(index : int) -> bool:
	if 0 <= index and index < items.size():
		items.remove_at(index)
		emit_changed_deferred()
		return true
	return false

func has_free_space() -> bool:
	return items.size() - 1 < max_items

func emit_changed_deferred() -> void:
	if not _emit_changed_requested:
		_emit_changed_requested = true
		_emit_changed.call_deferred()

func _emit_changed() -> void:
	if _emit_changed_requested:
		_emit_changed_requested = false
		changed.emit()
