extends Node
## Реализация логики обработки события использования SimpleItem.Type.ALARM_POTION
##
## Создайте уникальный ресурс [SimpleItems], установите свойство ресурса[br]
## [enum SimpleItems.type] = [member SimpleItem.Type.ALARM_POTION], создайте экземпляр этого скрипта,
## задайте ресурс в свойство [member item], передайте в свойство [param buildings_root] ссылку на
## узел родительский для зданий [Building], которые будут закрываться при срабатывании [signal Item.used].

## Ссылка на тип объекта, использование которого отслеживается.
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

## Ссылка на узел, среди дочерних элементов которго, будут отысканы и заперты [Building].
@export var buildings_root : Node

## Реализация запирания [Building] дочерних [param buildings_root].
func alarm() -> void:
	if buildings_root:
		for child in buildings_root.get_children():
			if child is Building:
				child.locked = true
