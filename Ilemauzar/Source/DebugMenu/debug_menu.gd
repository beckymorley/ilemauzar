extends Control

class_name DebugMenu

var debug_items : DebugItemArray

var debug_title_item : DebugMenuTitle

var next_item_padding = Vector2( 0,10)

var padding = Vector2(10, 10)

var item_height : int = 20

var container_debug : Array

export (int) var outer_margin = 10
export (int) var item_margin = 10

var menu_bg : ColorRect
export (Vector2) var menu_position 
export (Vector2) var menu_size = Vector2(300, 300)
export (Color) var menu_colour 
var debug_item_size : Vector2

var child_item_dict : Array
var child_item_cache : Array

var container_items : VBoxContainer

var outer_menu_container : MarginContainer
var outer_list_container : VBoxContainer
var item_margin_container : MarginContainer
var item_list_container : VBoxContainer

var item_list : Array

func _ready() -> void:
	visible = false
	set_size(menu_size)
	debug_items = DebugItemArray.new()
	debug_items = load_debug_items()
	
	outer_menu_container = $PanelContainer/OuterMarginContainer
	outer_list_container = $PanelContainer/OuterMarginContainer/OuterListContainer
	item_margin_container = $PanelContainer/OuterMarginContainer/OuterListContainer/ItemMarginContainer
	item_list_container = $PanelContainer/OuterMarginContainer/OuterListContainer/ItemMarginContainer/ItemListContainer
	
	debug_title_item = DebugMenuTitle.new("Debug Menu", item_height, false)
	
	generate_items(item_list_container)
	
	for item in item_list:
		item_list_container.add_child(item)
		
	update_containers()
	connect_signals()
	update()
	
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
	update_container(outer_menu_container)
	update_container(outer_list_container)
	update_container(item_margin_container)
	update_container(item_list_container)

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
	create_container_outline(outer_menu_container, Color.black)
	create_container_outline(outer_list_container, Color.webmaroon)
	create_container_outline(item_margin_container, Color.darkblue)
	create_container_outline(item_list_container, Color.darkgreen)

func get_position() -> Vector2:
	return Vector2(margin_left, margin_top)

func generate_items(parent):
	var position = parent.get_position() 
	var ItemType = DebugItemType.new()
	for item in debug_items.items:
		if(item.type == ItemType.Type.TICKBOX):
			var toggle_item = DebugToggle.new(item.string_id, item.description, item.value, position)
			toggle_item.set_size(Vector2(100, 20))
			if(item.parent_id == ""):
				item_list.push_back(toggle_item)
		if(item.type == ItemType.Type.TEXT_INPUT_BUTTON):
			var text_input_button = DebugTextInputButton.new(item.string_id, item.description, item.value, position)
			text_input_button.rect_size.y = 20
			if(item.parent_id == ""):
				item_list.push_back(text_input_button)
		if(item.type == ItemType.Type.TEXT_INPUT):
			var text_input = DebugTextInput.new(item.string_id, item.description, item.value, position)
			text_input.rect_size.y = 20
			if(item.parent_id == ""):
				item_list.push_back(text_input)
			else:
				add_to_child_cache(text_input, item.parent_id)
		if(item.type == ItemType.Type.BUTTON):
			var button = DebugButton.new(item.string_id, item.description)
			if(item.parent_id == ""):
				item_list.push_back(button)
		if(item.type == ItemType.Type.TEXT_INPUT_STRUCT_BUTTON):
			var struct_container = VBoxContainer.new()
			parent.add_child(struct_container)
			var child_items = get_child_items(item.string_id)
			var child_objects : Array
			for child in child_items: 
				var child_object = find_cache_item_by_debug_id(child)
				remove_child_from_cache(child)
				child_objects.push_back(child_object)
			var struct_button = DebugDataStructButton.new(item.string_id, item.description, child_objects, parent)
			item_list.push_back(struct_button)
			#position += Vector2(0, 20)
		if(item.type == ItemType.Type.ITEM_GROUP):
			var item_group = DebugItemGroup.new(item.name, {} , position, true)
			
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
