class_name Builder
extends Node
## Класс управления сценами.
##
## 

## Испускается, когда персонаж игрока создается или удаляется.
signal player_changed(player : PlayerCharacter)

## Запакованная главнае сцена.
@export var main_map_scn : PackedScene
## Запакованная сцена персонажа игрока.
@export var player_scn : PackedScene

## Ссылка на персонажа игрока.
var player : PlayerCharacter
## Ссылка на текующую карту в дереве.
var current_map : Map

## Есть ли в очереди отложенный вызод.
var _deffered := false
## Экземпляры управляемых сцен.
var _maps : Array[Map] = []


## Отложенный запуск первой загрузки главной сцены.
func _ready() -> void:
	_build.call_deferred()

## Инсценирование и добавление новой сцены в список управляемых сцен.
func add_map(map_scn : PackedScene) -> Map:
	var map := map_scn.instantiate() as Map
	_maps.append(map)
	return map

## Запрос отложенной перестройка всех сцен. Удаление всех сцен и новое создание главное сцены.
func rebuild() -> void:
	assert(not _deffered)
	if not _deffered:
		_deffered = true
		_rebuild.call_deferred()

## Запрос отложенной смена на указанную карту с переносом персонажа игрока в казанную точку.
func change_map(next_map : Map, exit_point : Node2D) -> bool:
	assert(not _deffered)
	assert(next_map in _maps)
	if not _deffered and next_map in _maps:
		_deffered = true
		_change_map.call_deferred(next_map, exit_point)
		return true
	return false

## Перестройка. Удаление всех сцен и новое создание главное сцены.
## Вместо этого метода используйте [member rebuild()]
func _rebuild() -> void:
	_deffered = false
	_destruct()
	_build()
	player.hint_interactive_message.emit("Ваш персонаж погиб. Мир перезапущен.")

## Уничтожение всех управляемых сцен.
## Этот метод не рекомендуется использоват напрямую.
func _destruct() -> void:
	player_changed.emit(null)
	
	for map in _maps:
		if is_instance_valid(map):
			if map.is_inside_tree():
				remove_child(map)
			map.free()
			assert(not is_instance_valid(map))
	_maps.clear()
	
	assert(not is_instance_valid(player))
	player = null

## Создание наной главной сцены и сцены персонажа игрока.
## Этот метод не рекомендуется использоват напрямую.
func _build() -> void:
	player = player_scn.instantiate() as PlayerCharacter
	player.dead.connect(rebuild)
	
	var map = add_map(main_map_scn)
	
	_change_map(map, map.exit_point)
	
	player_changed.emit(player)

## Извлечение текущей сцены из дерева, возращение сцены [param next_map] в дерево и 
## перенос сцены персонажа игрока в точку [prarm exit_point]
## Вместо этого метода используйте [member change_map()]
func _change_map(next_map : Map, exit_point : Node2D) -> void:
	_deffered = false
	
	if is_instance_valid(current_map):
		if current_map.is_inside_tree():
			remove_child(current_map)
		current_map = null
	
	if player.get_parent():
		player.get_parent().remove_child(player)
	
	assert(not player.get_parent())
	
	current_map = next_map
	next_map.add_child(player)
	add_child(next_map)
	player.global_position = exit_point.global_position
	player.set_direction(exit_point.transform.x)



















