extends Control

class_name DebugMenu

var debug_items : DebugItemArray

var debug_title_item : DebugMenuTitle

var next_item_padding = Vector2( 0,10)

var padding = Vector2(10, 10)

var item_height : int = 20

var container_debug : Array

export (int) var outer_margin = 10

var menu_bg : ColorRect
export (Vector2) var menu_position 
export (Vector2) var menu_size = Vector2(300, 300)
export (Color) var menu_colour 
var debug_item_size : Vector2

var child_item_dict : Array
var child_item_cache : Array
var margin_container : MarginContainer
var panel : PanelContainer
var container_main : VBoxContainer
var container_items : VBoxContainer

func _ready() -> void:
	visible = false
	set_size(menu_size)
	debug_items = DebugItemArray.new()
	debug_items = load_debug_items()
	create_menu()
	create_title()
	create_item_container()
	connect_signals()
	
func connect_signals():
	debug_title_item.connect("title_expand_toggle", self, "_on_DebugTitleExpand_toggled")
	
func _on_DebugTitleExpand_toggled(toggled : bool):
	if(!toggled):
		container_items.hide()
	else:
		container_items.show()
	update()

func load_debug_items() -> DebugItemArray:
	var data = DebugItemDataGetter.new()
	return data.get_data()

func create_title():
	debug_title_item = DebugMenuTitle.new("Debug Menu", item_height, false)
	container_main.add_child(debug_title_item)

func create_menu() -> void:
	panel = $PanelContainer
	margin_container = $PanelContainer/MarginContainer
	container_main = VBoxContainer.new()
	container_main.set_size(menu_size)
	add_container(container_main, Vector2(10, 10), margin_container)

func add_container(container : Container, relative_position: Vector2, parent_container : Container):
	if(parent_container):
		parent_container.add_child(container)
		container.margin_left = relative_position.x
		container.margin_top = relative_position.y
		container.size_flags_horizontal = SIZE_EXPAND
		container.size_flags_vertical = SIZE_EXPAND
		update_container(parent_container)
	
func create_container_outline(in_container, in_colour):
	var position = in_container.rect_position
	var margins = Vector2(in_container.margin_left, in_container.margin_top)
	var size = in_container.rect_size
	draw_line(position, position + Vector2(size.x, 0), in_colour)
	draw_line(position + Vector2(size.x, 0), position + size, in_colour)
	draw_line(position + size, position + Vector2(0, size.y), in_colour)
	draw_line(position + Vector2(0, size.y), position, in_colour)
	
func update_container(container : Container):
	container.visible = false
	container.call_deferred("set_visible", true)
	
func update_containers():
	update_container(container_main)
	update_container(margin_container)
	update_container(container_items)

func create_item_container():
	container_items = VBoxContainer.new()
	container_items.set_size(menu_size)
	container_items.size_flags_horizontal = SIZE_EXPAND
	container_items.size_flags_vertical = SIZE_EXPAND
	container_items.add_constant_override("separation", 0)
	generate_items(container_items)
	var items_position = margin_container.rect_global_position +  Vector2(0, debug_title_item.get_height())
	add_container(container_items, items_position, margin_container)

func get_container_position(in_container: Container) -> Vector2:
	return in_container.get_rect().position

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("debug_menu"):
		if(visible):
			set_visible(false)
		else:
			call_deferred("set_visible", true)
	update()
		
func _draw():
	create_container_outline(margin_container, Color.black)
	create_container_outline(container_main, Color.webmaroon)
	create_container_outline(container_items, Color.darkblue)

func get_position() -> Vector2:
	return Vector2(margin_left, margin_top)

func generate_items(parent):
	var position = debug_title_item.get_position() + Vector2(0, debug_title_item.get_height()) + next_item_padding	
	var ItemType = DebugItemType.new()
	for item in debug_items.items:
		if(item.type == ItemType.Type.TICKBOX):
			var toggle_item = DebugToggle.new(item.string_id, item.description, item.value, position)
			toggle_item.set_size(Vector2(100, 20))
			if(item.parent_id == ""):
				container_items.add_child(toggle_item)
			position.y += toggle_item.get_height()
		if(item.type == ItemType.Type.TEXT_INPUT_BUTTON):
			var text_input_button = DebugTextInputButton.new(item.string_id, item.description, item.value, position)
			text_input_button.rect_size.y = 20
			if(item.parent_id == ""):
				parent.add_child(text_input_button)
			position.y += 30
		if(item.type == ItemType.Type.TEXT_INPUT):
			var text_input = DebugTextInput.new(item.string_id, item.description, item.value, position)
			text_input.rect_size.y = 20
			if(item.parent_id == ""):
				parent.add_child(text_input)
			else:
				add_to_child_cache(text_input, item.parent_id)
			position.y += 20
		if(item.type == ItemType.Type.BUTTON):
			var button = DebugButton.new(item.string_id, item.description, position)
			if(item.parent_id == ""):
				parent.add_child(button)
			position += Vector2(0, 20)
		if(item.type == ItemType.Type.TEXT_INPUT_STRUCT_BUTTON):
			var child_items = get_child_items(item.string_id)
			var child_objects : Array
			for child in child_items: 
				var child_object = find_cache_item_by_debug_id(child)
				remove_child_from_cache(child)
				child_objects.push_back(child_object)
			var struct_button = DebugDataStructButton.new(item.string_id, item.description, child_objects, position)
			add_child(struct_button)
			position += Vector2(0, 20)
		if(item.type == ItemType.Type.ITEM_GROUP):
			var item_group = DebugItemGroup.new(item.name, {} , position, true)
			add_child(item_group)
			
func compare_parent_value_to_string(a, b):
	return a["parent"] == b
	
func compare_children_values_to_string(a, b):
	return a["children"].has(b)
	
func compare_string_to_debug_id(a, b):
	return a == b.debug_id

func add_to_child_cache(child, parent_key_string):
	var result = child_item_dict.bsearch_custom(parent_key_string, self, "compare_parent_value_to_string", true)
	if(result >= 0 and child_item_dict.size() > 0):
		var value = child_item_dict[result-1]["children"]
		value.push_back(child.debug_id)
		child_item_dict[result-1]["children"] = value
	else:
		var new_dict = {"parent" : parent_key_string, "children" : [child.debug_id]}
		child_item_dict.push_back(new_dict)
	child_item_cache.push_back(child)
	
func remove_child_from_cache(child_id : String):
	#var result = child_item_dict.bsearch_custom(child_id, self "compare_children_values_to_string")
	#if(result):
	pass

func get_child_items(parent_id : String): 
	var result = child_item_dict.bsearch_custom(parent_id, self, "compare_key_to_string", true)
	if(result >= 0 and result < child_item_dict.size()):
		return child_item_dict[result]["children"]

func find_cache_item_by_debug_id(in_debug_id):
	for item in child_item_cache:
		if(item.debug_id == in_debug_id):
			return item
