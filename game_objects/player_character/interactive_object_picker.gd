extends ShapeCast2D


func use(user : PlayerCharacter) -> InteractiveObject:
	for collision in collision_result:
		if collision.collider is InteractiveObject:
			var interactive := collision.collider as InteractiveObject
			if interactive.can_use_by(user):
				if interactive.use_by(user):
					return interactive
	return null
