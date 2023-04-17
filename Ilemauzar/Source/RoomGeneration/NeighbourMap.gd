extends Node

#Should be nativised
class_name NotNeighbourMap

var room
var neighbours : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _init(in_room : MyRoom) -> void:
	room = in_room
	
func add_neigbour(neighbour : MyRoom ) -> void:
	neighbours.push_back(neighbour)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
