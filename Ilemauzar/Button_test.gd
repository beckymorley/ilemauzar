extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.add_listener("struct_button_pressed", self, "_on_StructButton_pressed")


func _on_StructButton_pressed(values):
	var label_text : String
	for value in values: 
		label_text += str(value) + ",  "
	text = label_text

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
