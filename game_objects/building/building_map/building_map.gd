class_name BuildingMap
extends Map

@export var exit_point : ExitPoint

var building : Building


func _notification(what : int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if is_instance_valid(building):
			building.queue_free() ## BAD
