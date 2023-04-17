extends CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.add_listener('collision_signal', self, "_on_DebugMenu_show_collision_debug")
	GlobalSignal.add_listener('debug_toggled', self, "_on_DebugToggle_toggled")
	visible = false
	set_process(false)

func _on_RoomGeneration_show_collision_debug(enable):
	visible = enable

func _on_DebugToggle_toggled(toggle_name, toggle):
	if(toggle_name == "collision_show"):
		visible = toggle
