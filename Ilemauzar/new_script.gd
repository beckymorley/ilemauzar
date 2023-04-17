extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var m = Movement.new()
	var speed = 10
	var direction = Vector2(1, 1)
	var position = Vector2(0, 0)
	var next_position = m.get_next_position(position, direction, speed);
	print("Next position: (", next_position.x, ", ", next_position.y, ")")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
