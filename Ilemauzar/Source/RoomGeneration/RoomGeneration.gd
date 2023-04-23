extends Node2D

signal grid_debug(enable)

var RoomHelper = preload("res://Source/RoomGeneration/RoomHelper.gd")

# generation area
export(int, 10, 100) var Radius
var Centre

export(Color) var RoomFillColour
export(Color) var RoomOutlineColour
var RoomHeightRange
var RoomWidthRange

const CellSize = RoomHelper.cell_size

export(int) var MeanWidth
export(int) var MeanHeight
export(int) var WidthVariance
export(int) var HeightVariance

var Rectangles: Array
var RoomMin
var RoomMax

var circle_debug : DebugToggle
var grid_debug : DebugToggle
var collision_debug : DebugToggle


var show_debug_circle = false
var show_debug_grid = false
var show_collision_debug = false
var debug_grid
var separate = false

onready var room_inst = preload("res://Source/RoomGeneration/MyRoom.tscn")

export(int, 100) var NumberOfRooms = 10

func _ready():
	randomize()
	register_emit_signals()
	register_connect_signals()
	Radius *= CellSize
	Centre = Vector2(Radius, Radius)
	debug_grid = Grid.new(CellSize, Vector2(Centre.x/CellSize*2, Centre.y/CellSize*2), Color(0.39, 0.39, 0.39))
	add_child(debug_grid)
	
func register_emit_signals():
	GlobalSignal.add_emitter("collision_debug", self)
	GlobalSignal.add_emitter("grid_debug", self)

func register_connect_signals():
	GlobalSignal.add_listener("debug_toggled", self, "_on_DebugToggle_toggled")
	GlobalSignal.add_listener("debug_button_pressed", self, "_on_DebugButton_pressed")
	GlobalSignal.add_listener("struct_button_pressed", self, "_on_DebugStructButton_pressed")
	
func _on_DebugToggle_toggled(debug_id : String, toggled):
	if(debug_id == "radius_show"):
		set_show_debug_circle(toggled)
	
func _on_DebugButton_pressed(debug_id : String):
	if(debug_id == "separate_rooms"):
		separate = !separate
	elif(debug_id == "clear_rooms"):
		clear_rooms()

func _on_DebugStructButton_pressed(debug_id: String, in_struct: Array):
	if(debug_id == "room_generator_generate_rooms"):
		MeanWidth = in_struct[0]
		MeanHeight = in_struct[1]
		WidthVariance = in_struct[2]
		HeightVariance = in_struct[3]
		NumberOfRooms = in_struct[4]
		var MinWidth = MeanWidth - WidthVariance
		var MaxWidth = MeanWidth + WidthVariance
		var MinHeight = MeanHeight - HeightVariance
		var MaxHeight = MeanHeight + HeightVariance
		RoomHeightRange = IntRange.new(MinHeight, MaxHeight)
		RoomWidthRange = IntRange.new(MinWidth, MaxWidth)
		generate_room_set(NumberOfRooms)
	
func generate_random_rect():
	var size = get_rand_vec2(RoomWidthRange, RoomHeightRange)
	var scaled_size = scale_vec2_to_grid(size)
	var new_rect = room_inst.instance()
	var location = getRandomPointInCircle(Radius) + Centre
	location -= Vector2(size.x/2, size.y/2)
	location = snap_vec2_to_grid(location)
	new_rect.init(scaled_size, location, RoomFillColour, RoomOutlineColour)
	new_rect.init_debug(Grid.new(CellSize, size, Color(0.257, 0.251, 0.412)), show_debug_grid)
	Rectangles.push_back(new_rect)
	add_child(new_rect, true)

func RoundToTile(value, tile_size):
	return floor(((value + tile_size - 1)/tile_size))*tile_size

func generate_room_set(room_count):
	while room_count > 0:
		generate_random_rect()
		room_count-=1

func set_show_debug(enable):
	show_debug_grid = enable
	for rect in Rectangles:
		rect.set_show_debug(enable)
	if(debug_grid):
		debug_grid.set_should_draw(enable)
	update()

func set_show_debug_circle(enable):
	show_debug_circle = enable
	update()			
			
func print_toggle_state(name : String, state : bool) -> void:
	var state_string
	if(state):
		state_string = "on"
	else:
		state_string = "off"
	print(name, ": ", state_string)
	
func getRandomPointInCircle(radius):
	var t = 2*PI*randf()
	var u = 2* randf()
	var r 
	if u > 1:
		r = 2-u
	else:
		r = u
	return Vector2(RoundToTile(radius*r*cos(t), CellSize), RoundToTile(radius*r*sin(t), CellSize))

func get_rand_vec2(range_x, range_y):
	var x = randi() % (range_x._max) + range_x._min
	var y = randi() % (range_y._max) + range_y._min
	return Vector2(x, y)
	
func snap_vec2_to_grid(vector):
	return Vector2(int(vector.x) - int(vector.x) % CellSize, int(vector.y) - int(vector.y) % CellSize)

func scale_vec2_to_grid(vector):
	return Vector2(int(vector.x) * CellSize, int(vector.y) * CellSize)

func _draw():
	if(show_debug_circle):
		draw_circle(Centre, Radius, Color(0.255, 0.255, 0.255))

var time =0

var rooms_to_separate : Array

func _physics_process(delta):
	time += delta
	if(int(time) % 1 == 0):
		if(separate):
			if(rooms_to_separate.size() == 0):
				if(is_any_room_intersecting()):
					rooms_to_separate = get_all_rooms_with_intersect()
				else:
					separate = false
			else:
				separate_rooms(rooms_to_separate)
				rooms_to_separate = get_all_rooms_with_intersect()


func is_any_room_intersecting():
	for room in Rectangles:
		if(RoomHelper.has_intersecting_rooms(room)):
			return true
			
	return false

func get_all_rooms_with_intersect():
	var overlapping_rooms : Array
	for room in Rectangles:
		if(RoomHelper.has_intersecting_rooms(room)):
			overlapping_rooms.push_back(room)
	return overlapping_rooms
	
func separate_rooms(Rooms):
	for room_outer in Rooms:
		for room_inner in Rooms:
			if(room_outer == room_inner):
				continue
			if(!RoomHelper.are_rooms_intersecting(room_inner, room_outer, false)):
				continue
			
			var direction = (room_inner.get_centre() - room_outer.get_centre()).normalized()
			
			RoomHelper.move_room(room_outer, -direction)
			RoomHelper.move_room(room_inner, direction)
	
func clear_rooms():
	for room in Rectangles:
		room.queue_free()
	Rectangles.clear()

