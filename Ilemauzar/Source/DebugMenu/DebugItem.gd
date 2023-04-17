extends Node

class_name DebugItem

var string_id : String
var description : String
var type : int
var value
var parent_id : String

#var children: Array

func _init(in_string : String, in_desc : String, in_type : int, default_value, in_parent_id : String = "") -> void:
	string_id = in_string
	description = in_desc
	type = in_type
	value = default_value
	parent_id = in_parent_id
	
#func add_child_item(in_child : DebugItem) -> void:
	#children.push_back(in_child)
