# A container for min and max integer ranges

extends Node

class_name IntRange

var _min
var _max

func _init(init_min:int = 0, init_max:int =0):
	_min = init_min
	_max = init_max
