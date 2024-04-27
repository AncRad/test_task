extends Node

@export var item : SpecialItem:
	set(value):
		if item:
			item.used.disconnect(alarm)
		
		item = value
		
		if item:
			item.used.connect(alarm.unbind(1))

@export var buildings_root : Node

func alarm() -> void:
	if buildings_root:
		for child in buildings_root.get_children():
			if child is Building:
				child.locked = true
