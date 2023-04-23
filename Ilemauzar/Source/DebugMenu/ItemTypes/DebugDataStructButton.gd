extends Control

class_name DebugDataStructButton

signal struct_button_pressed(debug_id, value)

var debug_id : String
var button : Button
var outer_container : VBoxContainer
var inner_margin : MarginContainer
var inner_list : VBoxContainer
var child_items : Array

var signal_values : Array

func _init(name : String, text : String, in_child_items: Array, in_parent ) -> void:
	debug_id = name
	create_button(text)
	add_child_items(in_child_items)
	initialise_containers(in_parent)
	button.connect("pressed", self, "_on_Button_pressed")
	GlobalSignal.add_emitter("struct_button_pressed", self)

func initialise_containers(var parent):
	outer_container = VBoxContainer.new()
	outer_container.add_constant_override("separation", 25)
	parent.add_child(outer_container)
	inner_margin = MarginContainer.new()
	inner_margin.add_constant_override("margin_left", 7)
	
	inner_margin.add_child(inner_list)
	
	outer_container.add_child(button)
	outer_container.add_child(inner_margin)
	

func add_child_items(children : Array) -> void:
	inner_list = VBoxContainer.new()
	inner_list.add_constant_override("separation", 25)
	for child in children:
		inner_list.add_child(child)
		child_items.push_back(child)
	
func create_button(text : String) -> void:
	button = Button.new()	
	button.text = text

func get_height():
	return button.size.y
	
func get_child_data() -> Array:
	var data : Array
	for item in child_items: 
		var user_input = int(item.text_input.text)
		var default_input = int(item.text_input.placeholder_text)
		if(user_input > 0):
			data.push_back(user_input)
		elif(default_input > 0):
			data.push_back(default_input)
	return data
	
func _on_Button_pressed():
	signal_values = get_child_data()
	emit_signal("struct_button_pressed", debug_id, signal_values)
	outer_container.release_focus()
	
