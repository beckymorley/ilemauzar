extends Control

class_name DebugItemGroup

var container : VBoxContainer
var indent_size : int
var child_items : Array

var label : Label

func _init(name : String, in_child_items, in_position : Vector2, expand : bool):
	label = Label.new()
	label.set_position(in_position)
	label.text = name;
	container = VBoxContainer.new()
	container.set_position(in_position + Vector2(0,20))
	container.margin_left = indent_size
	for	item in child_items: 
		container.add_child(item)
	
