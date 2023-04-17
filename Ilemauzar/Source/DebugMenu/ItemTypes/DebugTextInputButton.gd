extends Control

class_name DebugTextInputButton

signal input_button_pressed(debug_id, value)

var debug_id : String
var text_input : LineEdit
var button : Button
var container : HBoxContainer

func _init(name : String, text : String, default: int, position : Vector2 ) -> void:
	debug_id = name
	create_button(text)
	create_line_edit(default)
	create_container(position)
	button.connect("pressed", self, "_on_Button_pressed")
	GlobalSignal.add_emitter("input_button_pressed", self)
	
func create_container(position : Vector2) -> void:
	container = HBoxContainer.new()
	container.set_position(position)
	container.add_child(text_input)
	container.add_child(button)
	add_child(container)
	
func create_button(text : String) -> void:
	button = Button.new()	
	button.text = text

func create_line_edit(default) -> void:
	text_input = LineEdit.new()
	text_input.placeholder_text = str(default)

func get_height():
	return button.size.y

func _on_Button_pressed():
	var value = 0
	var user_input = int(text_input.text)
	var default_input = int(text_input.placeholder_text)
	if(user_input > 0):
		value = user_input
	elif(default_input > 0):
		value = default_input
	emit_signal("input_button_pressed", debug_id, value)
	container.release_focus()
	
