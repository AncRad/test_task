class_name InventoryPanel
extends PanelContainer
## Глафическая панель управления [ItemContaner]
##
## Выводит в качестве кнопок с иконкой изображения предметов хранимых в [member container],
## позволяет выделять курсором мыши кнопки с иконкой, отображает название и описание выделенного
## предмета, испускает сиганлы [signal button_pressed], [signal item_selected].

## Испускается по нажатию кнопки.
signal button_pressed(button : int)

## Испускается по выделению ячейки со словарем
## [param item] как [Item], [param container] как [ItemContainer], [param user] как [PlayerCharacter],
## или пустой словарь, если выделено ничего.
signal item_selected(item : Dictionary)

## Сигнал создан по требованию, нигде не используется, не испускается.
signal time_to_change_buttons

## Ссылка на контейнер предметов для управления.
@export var container : ItemContainer:
	set(value):
		if value != container:
			if container:
				container.changed.disconnect(update)
			
			container = value
			
			if container:
				container.changed.connect(update)
			
			_selected_item_type = null
			update()

## Текстура пустой ячейки.
@export var empty_texture : Texture:
	set(value):
		empty_texture = value
		update()

## Текстура иконки отсутствующей текстуры предмета.
@export var error_texture : Texture:
	set(value):
		error_texture = value
		update()

## Контекст перевода.
@export_group('Translation', 'translation_')
## Ключи для [Translation] для вывода пустого названия и пустого описания типа предмета.
@export var translation_context := &'inventory'
## Ключ перевода пустого названия.
@export var translation_no_name := &'no_name'
## Ключ перевода пустого описания.
@export var translation_no_description := &'no_description'

## Обновлен ли интерфейс. Используется для отложенного обновления.
var _updated := true

## Тип последнего выделенного предмета.
var _selected_item_type : Item


func _ready() -> void:
	(%Buttons as Tree).create_item()
	update_selected(null)

## Запрос отложенного обновления. Ничего не делает, если [param visible] == false
func update() -> void:
	if visible and _updated:
		_updated = false
		_update.call_deferred()


## Добавляет кнопку на панель кнопок, возвращает индекс новой кнопки.
func add_button(text : String, icon : Texture = null) -> int:
	var tree := %Buttons as Tree
	var button := tree.create_item(tree.get_root())
	button.set_text(0, text)
	button.set_icon(0, icon)
	button.set_selectable(0, true)
	button.set_custom_color(0, Color.WHITE)
	return button.get_index()

## Выключает указанную кнопку на панели кнопок.
func disable_button(index : int) -> void:
	var root := (%Buttons as Tree).get_root()
	assert(root.get_child_count() > index)
	if root.get_child_count() > index:
		root.get_child(index).set_selectable(0, false)
		root.get_child(index).set_custom_color(0, Color.WHITE.darkened(0.3))

## Включает указанную кнопку на панели кнопок.
func enable_button(index : int) -> void:
	var root := (%Buttons as Tree).get_root()
	assert(root.get_child_count() > index)
	if root.get_child_count() > index:
		root.get_child(index).set_selectable(0, true)
		root.get_child(index).set_custom_color(0, Color.WHITE)

## Очищает кнопки на панели кнопок.
func clear_buttons() -> void:
	var tree := %Buttons as Tree
	tree.clear()
	tree.create_item()

## Возвращает [Item] тип выделенной ячейки, null если выделенна пустая ячейка.
func get_selected_item_type() -> Item:
	var list := %ItemList as ItemList
	if list.get_selected_items():
		assert(list.get_selected_items().size() <= 1)
		if list.get_selected_items().size() <= 1:
			var index := list.get_selected_items()[0]
			if index >= 0 and index < container.items.size():
				return container.items[index]
	return null

## Возвращает словарь с данными о выделенном объекте
## [param item] как [Item], [param container] как [ItemContainer],
## или пустой словарь, если выделено ничего.
func get_selected_item() -> Dictionary:
	var item_type := get_selected_item_type()
	if item_type:
		return {'item' : item_type, 'container' : container}
		#return {'item' : item_type, 'container' : container, 'user' : null}
	return {}

## Тоже самое что [member get_selected_item], то если выделения нет, то возвращает [param null].
## Нигде не используется, но создан по запросу в требованиях.
func get_selected_item_or_null() -> Variant:
	var item := get_selected_item()
	if item:
		return item
	return null

## Обновляет название и описание в панели выделенного объекта.
func update_selected(item_type : Item) -> void:
	if item_type:
		%SelectedNameLabel.text = item_type.get_visible_name()
		%SelectedInfoLabel.text = item_type.get_visible_description()
		return
	
	%SelectedNameLabel.text = tr(translation_no_name, translation_context)
	%SelectedInfoLabel.text = tr(translation_no_description, translation_context)

## Обработка выделения кнопки на панели кнопок. Интерпритируется как нажатие на кнопку, выделение
## кнопки сбрасывается, искускается сигнал [signal button_pressed].
func _on_buttons_item_selected() -> void:
	var tree := %Buttons as Tree
	var selected_button := tree.get_selected()
	selected_button.deselect(0)
	button_pressed.emit(selected_button.get_index())

func _on_visibility_changed() -> void:
	if visible:
		update()

## Обработка выделения предмета в листе предметов. Обновляется панель выделенного объекта
## [member update_selected()], испускается сигнал [signal item_selected]. Отключаеются или включаеются
## кнопки панели кнопок в зависимости от выделенной ячейки.
func _on_item_list_item_selected() -> void:
	var item := get_selected_item()
	if item:
		update_selected(item.item)
	else:
		var root := (%Buttons as Tree).get_root()
		for index in root.get_child_count():
			root.get_child(index).set_selectable(0, false)
		update_selected(null)
	item_selected.emit(item)

## Обновление TileList, состояния кнопок, описания предметов.
## Вместо этого метода следует вызывать [member update()]
func _update() -> void:
	_updated = true
	
	if not has_node('%ItemList'):
		return
	
	var list := %ItemList as ItemList
	
	if container:
		if list.item_count != container.max_items:
			list.clear()
			for index in container.max_items:
				list.add_item('', empty_texture, true)
		
		var selected_index := -1
		for index in maxi(container.items.size(), container.max_items):
			var item_type : Item
			var empty : bool = index >= container.items.size()
			if not empty:
				item_type = container.items[index]
			
			var texture : Texture
			if empty:
				texture = empty_texture
			else:
				texture = item_type.texture
			if not texture:
				texture = error_texture
			
			list.set_item_icon(index, texture)
			
			if _selected_item_type and selected_index == -1 and _selected_item_type == item_type:
				selected_index = index
				list.select(index, true)
			elif list.is_selected(index):
				list.deselect(index)
		
		if _selected_item_type and selected_index == -1:
			_selected_item_type = null
			_on_item_list_item_selected()
		
		update_selected(get_selected_item_type())
	
	else:
		list.clear()
		update_selected(get_selected_item_type())























