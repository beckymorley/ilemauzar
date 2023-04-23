extends Control

class_name DebugButton

signal debug_button_pressed(debug_id)

var debug_id: String
var button : Button

func _init(name : String, text : String) -> void:
	debug_id = name
	button = Button.new()
	button.text = text
	#button.set_position(position)
	add_child(button)
	button.connect("pressed", self, "_on_Button_pressed")
	GlobalSignal.add_emitter("debug_button_pressed", self)
	
func _on_Button_pressed():
	emit_signal("debug_button_pressed", debug_id)
