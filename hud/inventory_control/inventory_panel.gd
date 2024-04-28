class_name InventoryPanel
extends PanelContainer

signal button_pressed(button : int)
signal item_selected(item : Dictionary)
signal time_to_change_buttons

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

@export var empty_texture : Texture:
	set(value):
		empty_texture = value
		update()

@export var error_texture : Texture:
	set(value):
		error_texture = value
		update()

@export_group('Translation', 'translation_')
@export var translation_context := &'inventory'
@export var translation_no_name := &'no_name'
@export var translation_no_description := &'no_description'

var _updated := true
var _selected_item_type : Item


func _ready() -> void:
	(%Buttons as Tree).create_item()
	update_selected(null)

func update() -> void:
	if visible and _updated:
		_updated = false
		_update.call_deferred()


func add_button(text : String, icon : Texture = null) -> int:
	var tree := %Buttons as Tree
	var button := tree.create_item(tree.get_root())
	button.set_text(0, text)
	button.set_icon(0, icon)
	button.set_selectable(0, true)
	button.set_custom_color(0, Color.WHITE)
	return button.get_index()

func disable_button(index : int) -> void:
	var root := (%Buttons as Tree).get_root()
	assert(root.get_child_count() > index)
	if root.get_child_count() > index:
		root.get_child(index).set_selectable(0, false)
		root.get_child(index).set_custom_color(0, Color.WHITE.darkened(0.3))

func enable_button(index : int) -> void:
	var root := (%Buttons as Tree).get_root()
	assert(root.get_child_count() > index)
	if root.get_child_count() > index:
		root.get_child(index).set_selectable(0, true)
		root.get_child(index).set_custom_color(0, Color.WHITE)

func clear_buttons() -> void:
	var tree := %Buttons as Tree
	tree.clear()
	tree.create_item()


func get_selected_item_type() -> Item:
	var list := %ItemList as ItemList
	if list.get_selected_items():
		assert(list.get_selected_items().size() <= 1)
		if list.get_selected_items().size() <= 1:
			var index := list.get_selected_items()[0]
			if index >= 0 and index < container.items.size():
				return container.items[index]
	return null

func get_selected_item() -> Dictionary:
	var item_type := get_selected_item_type()
	if item_type:
		return {'item' : item_type, 'container' : container, 'user' : null}
	return {}

func get_selected_item_or_null() -> Variant:
	var item := get_selected_item()
	if item:
		return item
	return null


func update_selected(item_type : Item) -> void:
	if item_type:
		%SelectedNameLabel.text = item_type.get_visible_name()
		%SelectedInfoLabel.text = item_type.get_visible_description()
		return
	
	%SelectedNameLabel.text = tr(translation_no_name, translation_context)
	%SelectedInfoLabel.text = tr(translation_no_description, translation_context)


func _on_buttons_item_selected() -> void:
	var tree := %Buttons as Tree
	var selected_button := tree.get_selected()
	selected_button.deselect(0)
	button_pressed.emit(selected_button.get_index())

func _on_visibility_changed() -> void:
	if visible:
		update()

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























