extends Node2D

class_name Grid

export(int) var CellSize
export(Vector2) var GridSize
export(Color) var Colour

func _init(cell_size, grid_size, colour):
	CellSize = cell_size
	GridSize = grid_size
	Colour = colour
	visible = false
	GlobalSignal.add_listener('grid_debug', self, "_on_DebugToggle_show_grid_debug")
	GlobalSignal.add_listener('debug_toggled', self, "_on_DebugToggle_toggled")
	set_process(false)
	
func _on_DebugToggle_show_grid_debug(enable) -> void:
	visible = enable

func _draw() :
	for x in GridSize.x -1:
		draw_line(Vector2((x+1)*CellSize, 0), Vector2((x+1)*CellSize, (GridSize.y)*CellSize), Colour)
		for y in GridSize.y -1:
			draw_line(Vector2(0, (y+1)*CellSize), Vector2((GridSize.x) * CellSize, (y+1)*CellSize), Colour)

func _on_DebugToggle_toggled(toggle_name, toggled):
	if(toggle_name == "grid_show"):
		visible = toggled
