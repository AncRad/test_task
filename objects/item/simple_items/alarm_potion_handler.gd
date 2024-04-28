extends Node

@export var item : SimpleItems:
	set(value):
		if value and value.type != SimpleItems.Type.ALARM_POTION:
			assert(value.type == SimpleItems.Type.ALARM_POTION)
			return
		
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
