extends Control

class_name DebugToggle

var debug_id: String
var checkbutton : CheckButton

var on_icon_path = "res://checkbox_on.png"
var off_icon_path = "res://checkbox_off.png"

var on_icon
var off_icon

signal debug_toggled(debug_id, value)
	
func _init(name : String, text : String, default_state: bool, position : Vector2 ) -> void:
	debug_id = name
	checkbutton = CheckButton.new()
	init_icons()
	checkbutton.add_icon_override("off", off_icon)
	checkbutton.add_icon_override("on", on_icon)
	checkbutton.set_position(position)
	checkbutton.text = text
	checkbutton.toggle_mode = true
	checkbutton.set_size(Vector2(checkbutton.rect_size.x, 10))
	add_child(checkbutton)
	checkbutton.connect("toggled", self, "_on_CheckButton_toggled")
	GlobalSignal.add_emitter("debug_toggled", self)
	

func init_icons():
	var on_image = Image.new()
	on_image.load(on_icon_path)
	on_icon = ImageTexture.new()
	on_icon.create_from_image(on_image)
	
	var off_image = Image.new()
	off_image.load(off_icon_path)
	off_icon = ImageTexture.new()
	off_icon.create_from_image(off_image)
	

func get_state() -> bool:
	return checkbutton.is_pressed()
	
func toggle() -> void:
	checkbutton.toggle_mode = !checkbutton.toggle_mode
	
func get_name() -> String:
	return debug_id
	
func get_text() -> String: 
	return checkbutton.text
	
func _on_CheckButton_toggled(toggled):
	emit_signal("debug_toggled", debug_id, toggled)

func get_height():
	return checkbutton.rect_size.y;
