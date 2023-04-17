extends Label

class_name DebugMenuTitle

var expand_icon : Image
var expanded : bool
var item_rect : Rect2

signal title_expand_toggle(state)

func _init(name : String, height : int, in_expanded : bool):
	create_label(name, height)
	expanded = in_expanded
	connect("title_expand_toggle", self, "_on_ExpandToggle_pressed")
	
func create_label(in_text : String, height : int) -> void: 
	text = in_text
	rect_size.y = height
	
func _input(event):
	if event is InputEventMouseButton and event.is_action_pressed("left_click"):
		var bounds = Rect2(rect_global_position, rect_size)
		if bounds.has_point(event.position):
			expanded = !expanded
			emit_signal("title_expand_toggle", expanded)

func get_height():
	return rect_size.y
				
func _on_ExpandToggle_pressed(in_expanded : bool):
	#switch icon
	pass
