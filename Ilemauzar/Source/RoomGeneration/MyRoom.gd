extends Area2D

class_name MyRoom

var outline_set
var debug_grid
var debug_label_container
var debug_label

var Fill
var Outline
var Size
var Centre

var UID

var collision_shape

func _ready(): 
	UID = str(get_instance_id())
	init_debug_label()

func init(size, location, fill_colour, outline_colour):
	Size = size
	Fill = fill_colour
	Outline = outline_colour
	outline_set = []
	update_position(location)
	init_collision(Size)
	init_outline_set()

func get_rect() -> Rect2:
	var top_left = position - get_extents()
	var top_right = position + Vector2(get_extents().x, 0)
	var bottom_left = position - Vector2(0, get_extents().y)
	var bottom_right = position + get_extents()
	var rect_array = [top_left, top_right, bottom_left, bottom_right]
	var rect = Rect2(position, get_extents())
	return rect

func init_collision(size):
	collision_shape = CollisionShape2D.new()
	add_child(collision_shape)
	collision_shape.set_shape(RectangleShape2D.new())
	collision_shape.position = size/2
	collision_shape.get_shape().set_extents(size/2)

func get_extents() -> Vector2:
	return collision_shape.shape.extents
	
func left() -> int: 
	return int(position.x - get_extents().x)
	
func right() -> int: 
	return int(position.x + get_extents().x)
	
func top() -> int: 
	return int(position.y - get_extents().y)

func bottom() -> int: 
	return int(position.y + get_extents().y)
	
func topleft() -> Vector2:
	return Vector2(left(), top())

func topright() -> Vector2:
	return Vector2(right(), top())

func botleft() -> Vector2:
	return Vector2(left(), bottom())
	
func botright() -> Vector2:
	return Vector2(right(), bottom())

func get_room_id():
	return UID

func init_debug(grid, show_debug = false):
	debug_grid = grid
	debug_grid.position = Vector2.ZERO
	add_child(debug_grid)

func init_debug_label():
	#create label container to inherit z_index functionality
	debug_label_container = Node2D.new()
	debug_label_container.z_index = z_index+1
	add_child(debug_label_container)
	#create label and attach to container
	debug_label = Label.new()
	debug_label.text = UID + " (" + str(position.x).pad_decimals(0) + ", " + str(position.y).pad_decimals(0) + ")"
	debug_label.rect_position = - Vector2(debug_label.text.length(), debug_label.get_line_height())
	debug_label_container.add_child(debug_label)
	
func _draw():
	var rect = Rect2(Vector2.ZERO, Size)
	draw_rect(rect, Fill)

func create_line(start, end):
	var line = Line2D.new()
	line.add_point(start)
	line.add_point(end)
	line.z_index = z_index +1
	line.default_color = Outline
	line.width = 2
	return line

func init_outline_set():
	var start = Vector2.ZERO
	var end
	var i = 0
	while i < 4:
		end = start + Vector2(Size.x * sin(i * (PI/2)), Size.y * cos(i * PI/2))
		var line = create_line(start, end)
		add_child(line)
		outline_set.push_back(line)
		start = end
		i+=1
	
func update_position(new_position):
	position = new_position
	
	var Centre_x = position.x + (Size.x/2)
	var Centre_y = position.y + (Size.y/2)
	Centre = Vector2(Centre_x, Centre_y)
		
func move(new_position : Vector2, tile_size : int = 1):
	var new_x = position.x + round(new_position.x)*tile_size
	var new_y = position.y + round(new_position.y)*tile_size
	
	update_position(Vector2(new_x, new_y))
