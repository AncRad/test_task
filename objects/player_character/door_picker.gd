extends Area2D
## Класс логики взаимодействия с дверьми построек [DoorArea]
##
## Объект класса подразумевается как часть композиции 'Персонаж игрока'. Должен быть
## одним из дочерних элементов [PlayerCharacter].
## [br]Реализует логику поиска дверей [DoorArea] в пространстве и логику взаимодействия
## персонажа игрока с ними.
## [br]Для правильной работы должны быть заданы свойтсва [member user].

## Ссылка на родительский объект.
@export var user : PlayerCharacter

## Обработка пересечения с дверью [DoorArea]. Пытается открыть здание [Building]
##  ([member DoorArea.get_building()]), если оно закрыто, или войти в здание, если оно открыто.
func _on_area_entered(area : Area2D) -> void:
	if user:
		if area is DoorArea:
			var door := area as DoorArea
			var building := door.get_building()
			if building:
				if door.exterior:
					if building.is_locked() and building.can_unlock() and user.can_unlock():
						var yes := true
						if user.door_open_callback:
							yes = await user.door_open_callback.call()
						if yes:
							if user.unlock(building):
								pass # ok
					
					if building.can_enter():
						building.enter(user)
				
				else:
					if building.can_exit():
						building.exit(user)


