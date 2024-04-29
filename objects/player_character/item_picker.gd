class_name ItemPicker # Преименовать в DroppedItemPicker
extends Area2D
## Класс логики взаимодействия с брошенными предметами [PickupableItem]
##
## Объект класса подразумевается как часть композиции 'Персонаж игрока'. Должен быть
## одним из дочерних элементов [PlayerCharacter], устанавливает ссылку на себя
## в свойство [member PlayerCharacter.item_picker].
## [br]Реализует логику поиска брошенных предметов [PickupableItem] в пространстве и логику взаимодействия
## персонажа игрока с ними.
## [br]Для правильной работы должны быть заданы свойтсва [member user], [member container] и [member collision_mask].

## Запакованная сцена PickupableItem.
const PICKUPABLE_ITEM = preload("../pickupable_item/pickupable_item.tscn")

## Ссылка на родительский объект.
@export var user : PlayerCharacter:
	set(value):
		if value != user:
			if user:
				user.item_picker = null
			
			user = value
			
			if user:
				user.item_picker = self

## Ссылка на объект хранилища предметов.
@export var container : ItemContainer:
	set(value):
		if value != container:
			if container:
				container.changed.disconnect(_on_container_changed)
				_on_container_changed()
			container = value
			
			if container:
				container.changed.connect(_on_container_changed)
				_on_container_changed()

## Список [PickupableItem], которые будт проигнорированы один раз при вызове
## [member _on_area_entered]. Полезно для предотвращения нежелательного подбора только что выброшенных предметов.
var _area_ignore_once : Array[Area2D] = []

## Реакция на события обнаружения брошенных предметов. Подразумевается [param area] как [PickupableItem].
## Если предмет подбираемый и в хранилище есть место, то добавляет [Item] в хранилище, удаляет [PickupableItem] из мира.
## Если предмет не подбираемый, то пытается использовать его на [member user]
func _on_area_entered(area : Area2D) -> void:
	if area in _area_ignore_once:
		_area_ignore_once.erase(area)
		return
	
	if container:
		if area is PickupableItem:
			var pickupable_item := area as PickupableItem
			if pickupable_item.can_pickup():
				var item : Item = pickupable_item.item
				if item.is_storable():
					if container.can_append(item):
						if pickupable_item.pickup():
							if not container.append(item):
								assert(false)
				
				elif user and item.can_use_by(user):
					if pickupable_item.pickup():
						if not item.use_by(user):
							assert(false)

## Реакция на изменения состояния [member ItemContainer.has_free_space()]
## Если значение false, то отключает обнаружение предметов.
func _on_container_changed() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			if child.disabled == (container and container.has_free_space()):
				child.disabled = not child.disabled

## Может ли предт быть использован на [member user].
func can_use(item : Item) -> bool:
	if item and item.can_use_by(user):
		if item in container.items:
			return true
	return false

## Использует брошенный предмет на [member user].
func use(item : Item) -> bool:
	if can_use(item):
		if item.use_by(user):
			var ok := container.remove(container.items.find(item))
			assert(ok)
			return true
	return false

## Может ли предмет быть брошенным.
func can_drop(item : Item) -> bool:
	if item and item.can_drop(user):
		if item in container.items:
			return true
	return false

## Бросает предмет. Инсценирует [PickupableItem], добавляет на сцену, и удаляет [Item] из хранилища.
func drop(item : Item) -> bool:
	if can_drop(item):
		if container.remove(container.items.find(item)):
			_instantiate_pickupable_item.call_deferred(item, user.get_parent())
			return true
		else:
			assert(false)
	return false

## Инсценирование сцены [PickupableItem], установка в него типа объекта и прикрепление на сцену.
func _instantiate_pickupable_item(item : Item, parent : Node) -> void:
	var pickupable_item := PICKUPABLE_ITEM.instantiate() as PickupableItem
	pickupable_item.item = item
	_area_ignore_once.append(pickupable_item)
	parent.add_child(pickupable_item)
	pickupable_item.global_position = global_position






















