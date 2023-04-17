extends Node

class_name DebugItemArray

var items : Array

func sort_custom(obj , in_func : String):
	items.sort_custom(obj, in_func)

func sort():
	items.sort()

func slice(begin : int, end : int, step: int = 1, deep: bool = false):
	return items.slice(begin, end, step, deep)

func size():
	return items.size()

func shuffle():
	items.shuffle()

func rfind(what : DebugItem, from : int = -1):
	return items.rfind(what, from)

func resize(size : int):
	items.resize(size)

func remove(position: int):
	items.remove(position)

func push_front(value : DebugItem):
	items.push_front(value)

func push_back(value : DebugItem):
	items.push_back(value)

func pop_front():
	items.pop_front()

func pop_back():
	items.pop_back()

func pop_at(position : int):
	items.pop_at(position)

func get_min():
	items.min()

func get_max():
	items.max()

func invert():
	items.invert()

func insert(position : int, value : DebugItem):
	items.insert(position, value)

func get_hash():
	return items.hash()

func has(value : DebugItem):
	return items.has(value)

func front():
	items.front()

func find_last(value : DebugItem):
	return items.find_last(value)

func find(what : DebugItem, from : int = 0):
	return items.find(what, from)

func fill(value : DebugItem):
	items.fill(value)

func erase(value : DebugItem):
	items.erase(value)

func empty():
	return items.empty()

func duplicate_array(deep : bool = false):
	return items.duplicate(deep)

func count(value : DebugItem):
	return items.count(value)

func clear():
	items.clear()

func bsearch_custom(value : DebugItem, obj , in_func : String, before : bool = true):
	return items.bsearch_custom(value, obj , in_func , before)

func bsearch(value : DebugItem, before : bool = true):
	return items.bsearch(value, before)

func back():
	items.back()

func append_array(array: DebugItemArray):
	items.append_array(array.items)

func append(value : DebugItem):
	items.append(value)
