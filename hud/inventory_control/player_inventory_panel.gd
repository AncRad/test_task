extends InventoryPanel

@export_group('Translation', 'translation_')
@export var translation_use := &'use_item'
@export var translation_drop := &'drop_item'

@export var player : PlayerCharacter:
	set(value):
		if value != player:
			if player:
				container = null
			
			player = value
			
			if player:
				container = player.container

var _buttons_data : Array[StringName] = []


func _ready() -> void:
	super()
	update_buttons()
	button_pressed.connect(_on_button_pressed)

func get_selected_item() -> Dictionary:
	var item_type := get_selected_item_type()
	if item_type:
		return {'item' : item_type, 'container' : container, 'user' : player}
	return {}

func update_buttons() -> void:
	clear_buttons()
	add_button(tr(translation_use, translation_context))
	_buttons_data.append(&'use')
	add_button(tr(translation_drop, translation_context))
	disable_button(0)
	disable_button(1)
	
	_buttons_data.append(&'drop')
	var item := get_selected_item()
	if item:
		var item_type : Item = item.item
		var item_user : PlayerCharacter = item.user
		if item_user == player:
			var picker := player.item_picker
			if picker.can_use(item_type):
				enable_button(0)
			if picker.can_drop(item_type):
				enable_button(1)

func _on_item_list_item_selected() -> void:
	super()
	update_buttons()

func _on_button_pressed(button : int) -> void:
	if button < _buttons_data.size():
		var action : StringName = _buttons_data[button]
		var picker := player.item_picker
		var item_type := get_selected_item_type()
		if picker and item_type:
			match action:
				&'use':
					picker.use(item_type)
				
				&'drop':
					picker.drop(item_type)






















