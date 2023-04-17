extends Control

class_name DebugTextInput

var debug_id : String
var text_input : LineEdit
var description : Label
var container : HBoxContainer

func _init(name : String, text : String, default, position : Vector2 ) -> void:
	debug_id = name
	create_line_edit(default)
	create_label(text)
	create_container(position)

func create_line_edit(default) -> void:
	text_input = LineEdit.new()
	text_input.placeholder_text = str(default)
	
func create_label(in_text : String) -> void: 
	description = Label.new()
	description.text = in_text

func create_container(position : Vector2) -> void:
	container = HBoxContainer.new()
	container.set_position(position)
	container.add_child(description)
	container.add_child(text_input)
	add_child(container)
