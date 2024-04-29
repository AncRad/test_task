class_name ItemContainer
extends Node
## Хранилище предметов Item
##
## Массив Item с ограниченным размером [param max_items] и некоторыми функциями управления массивом с проверками.
## Отложенно испускает сигнал [signal changed] при изменении.

## Сигнал о изменении размера или содержимого массива.
signal changed

## Ограничение размера массива. Ограничивает максимальный размер, но не обрезает массив, если
## размер массива превысил значение.
@export_range(0, 20, 1)
var max_items : int = 10:
	set(value):
		if value != max_items:
			if value < 0 and value != items.size() or value < items.size():
				assert(false)
				return
			max_items = value
			emit_changed_deferred()

## Массив предметов. Если доступ осуществляется напрямую по имени свойствоа [param items],
## то подразумевается, что пользователь массива не будет его изменять.
## Сеттер массива очищает пустые ячейки, это необходимо для предотвращения попадания
## оставленных пустых ячеек в массив заданных из инспектора.
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

## Отметка об отложенном вызове в очереди.
var _emit_changed_requested := false


## Может ли быть массив пополнен объектов.
func can_append(item : Item) -> bool:
	return item and items.size() < max_items

func append(item : Item) -> bool:
	if can_append(item):
		items.append(item)
		emit_changed_deferred()
		return true
	return false

## Удалить ячейку.
func remove(index : int) -> bool:
	if 0 <= index and index < items.size():
		items.remove_at(index)
		emit_changed_deferred()
		return true
	return false

## Может ли быть массив пополнен.
func has_free_space() -> bool:
	return items.size() - 1 < max_items

## Запрос отложенного сигнала.
func emit_changed_deferred() -> void:
	if not _emit_changed_requested:
		_emit_changed_requested = true
		_emit_changed.call_deferred()

## Отложенное испускание сигнала. Ничего не делает если [param _emit_changed_requested] == [param false].
func _emit_changed() -> void:
	if _emit_changed_requested:
		_emit_changed_requested = false
		changed.emit()
