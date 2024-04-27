class_name BuildingMap
extends Map

var _building : Building


func _notification(what : int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if is_instance_valid(_building):
			_building.queue_free()

func get_exit_point() -> ExitPoint:
	return get_node('%ExitPoint') as ExitPoint

func get_building() -> Building:
	return _building
