extends Control

class_name DebugDataStructButton

signal struct_button_pressed(debug_id, value)

var debug_id : String
var button : Button
var container : VBoxContainer
var child_items : Array

var signal_values : Array

func _init(name : String, text : String, in_child_items: Array, position : Vector2 ) -> void:
	debug_id = name
	create_button(text)
	create_container(position, in_child_items)
	button.connect("pressed", self, "_on_Button_pressed")
	GlobalSignal.add_emitter("struct_button_pressed", self)
	
func create_container(position : Vector2, children : Array) -> void:
	container = VBoxContainer.new()
	container.add_constant_override("separation", 20)
	container.set_position(position)
	for child in children:
		add_child(child)
	#	container.add_child(child)
		child_items.push_back(child)
	#container.add_child(button)
	add_child(button)
	add_child(container)
	
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
	container.release_focus()
	
