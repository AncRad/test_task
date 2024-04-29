@tool
class_name Building
extends Node2D
## Класс экстерьера постройки
##
## Реализует логику построек. Меняет карту, когда игрок входит или выходит.

## Испускается при изменеии [param locked]
signal locked_changed(locked : bool)

## Свойство блокировки постройки. Значение [param false] игнорируется, если у здания нет интерьера.
@export var locked : bool = true:
	set(value):
		locked = value
		locked_changed.emit(locked)

## Ссылка на узел точка выхода из здания.
@export var exit_point : Node2D

## Ссылка на запакованную сцену интерьера [BuildingMap].
@export var interier_scn : PackedScene

## Сссылка на класс, управляющий сценами.
var builder : Builder

## Ссылка на экземпляр [BuildingMap], которым владеет этот экземпляр класса [Building].
## @deprecated
var interior : BuildingMap # переименовать в _interior

## Ссыдка на карту, которая владеет этим экземпляром [Building]
var _main_map : Map


## Обработка входа в дерево. Поиск родительских [Builder], [Map] для свойств [member builder] и
## [member _main_map]. Инициализация [member interier_scn] как [BuildingMap] если не инициализирована.
## Блокировка, если нет интерьера, или не обнаружен [member builder].
func _enter_tree() -> void:
	if Engine.is_editor_hint():
		return
	
	if interier_scn:
		if find_parent("Builder") is Builder:
			builder = find_parent("Builder")
		
		if builder:
			_main_map = builder.current_map
			assert(_main_map)
			
			if not interior:
				interior = builder.add_map(interier_scn) as BuildingMap
				interior.building = self
	
	if not builder or not interior:
		locked = true

## Запраживает смену карты у [member builder].
## Возвращает [param true] в случае успеха.
func enter(_entering : PlayerCharacter) -> bool:
	if can_enter():
		return builder.change_map(interior, interior.exit_point)
	return false

## Может ли при принимать игрока внутрь.
func can_enter() -> bool:
	return not locked and has_interior()

## Имеет ли интерьер.
func has_interior() -> bool:
	if Engine.is_editor_hint():
		return interier_scn != null
	else:
		return builder and interior and interior.exit_point

##Запраживает смену карты у [member builder].
## Возвращает [param true] в случае успеха.
func exit(_exiting : PlayerCharacter) -> bool:
	if can_exit():
		return builder.change_map(_main_map, exit_point)
	return false

## Может ли выпустить игрока наружу. Не зависит от состояния [member is_locked()]
func can_exit() -> bool:
	return builder and _main_map and exit_point

## Разблокировать. 
## Возвращает [param true] в случае успеха.
func unlock() -> bool:
	if can_unlock():
		locked = false
		return true
	return false

## Закрото ли здание. Возвращает всегда [param true], если здание не может принимать игрока.
func is_locked() -> bool:
	return locked

## Может ли быть здание открыто. Возвращает всегда [param false], если здание не может принимать игрока.
func can_unlock() -> bool:
	return locked and has_interior()












