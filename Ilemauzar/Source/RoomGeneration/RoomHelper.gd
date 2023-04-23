extends Node

class_name RoomHelper

const cell_size = 8
	
static func get_collision_rect(in_room : MyRoom) -> Rect2:
	var position = in_room.position
	var size = in_room.Size
	return Rect2(position, size)

static func has_intersecting_rooms(in_room : MyRoom) -> bool:
	var overlapping_rooms = get_intersecting_rooms(in_room)
	return overlapping_rooms.size() > 0


static func get_intersecting_rooms(in_room : MyRoom) -> Array:
	var intersecting_rooms : Array
	var overlapping_areas = in_room.get_overlapping_areas()
	for area in overlapping_areas: 
		if(are_rooms_intersecting(in_room, area, false)):
			var room_rect = get_collision_rect(in_room)
			var other_rect = get_collision_rect(area)
			var intersection = intersection(room_rect, other_rect)
			if(intersection.size.x >= cell_size or intersection.size.y >= cell_size):
				intersecting_rooms.push_back(area)
	return intersecting_rooms
	

static func intersection(rect : Rect2, other_rect : Rect2) -> Rect2:	
	var new_rect : Rect2
	new_rect = other_rect
	
	if(!rect.intersects(other_rect)):
		return Rect2()
	
	new_rect.position.x = max(other_rect.position.x, rect.position.x)
	new_rect.position.y = max(other_rect.position.y, rect.position.y)
	
	var other_rect_end = other_rect.end
	var rect_end = rect.end
	
	new_rect.size.x = min(other_rect_end.x, rect_end.x) - new_rect.position.x
	new_rect.size.y = min(other_rect_end.y, rect_end.y) - new_rect.position.y
	
	return new_rect
			

static func are_rooms_intersecting(room: MyRoom, other_room : MyRoom, include_borders = false ) -> bool: 
	var room_rect = get_collision_rect(room)
	var other_rect = get_collision_rect(other_room)
	
	return room_rect.intersects(other_rect, include_borders)

