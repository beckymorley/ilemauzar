extends Node

class_name MyRoomArray

var items : Array

func sort_custom(obj , in_func : String):
	items.sort_custom(obj, in_func)

func sort():
	items.sort()

func slice(begin : int, end : int, step: int = 1, deep: bool = false):
	items.slice(begin, end, step, deep)

func size():
	items.size()

func shuffle():
	items.shuffle()

func rfind(what : MyRoom, from : int = -1):
	items.rfind(what, from)

func resize(size : int):
	items.resize(size)

func remove(position: int):
	items.remove(position)

func push_front(value : MyRoom):
	items.push_front(value)

func push_back(value : MyRoom):
	items.push_back(value)

func pop_front():
	items.pop_front()

func pop_back():
	items.pop_back()

func pop_at(position : int):
	items.pop_at(position)

func min():
	items.min()

func max():
	items.max()

func invert():
	items.invert()

func insert(position : int, value : MyRoom):
	items.insert(position, value)

func hash():
	items.hash()

func has(value : MyRoom):
	items.has(value)

func front():
	items.front()

func find_last(value : MyRoom):
	items.find_last(value)

func find(what : MyRoom, from : int = 0):
	items.find(what, from)

func fill(value : MyRoom):
	items.fill(value)

func erase(value : MyRoom):
	items.erase(value)

func empty():
	items.empty()

func duplicate_array(deep : bool = false):
	items.duplicate(deep)

func count(value : MyRoom):
	items.count(value)

func clear():
	items.clear()

func bsearch_custom(value : MyRoom, obj , in_func : String, before : bool = true):
	items.bsearch_custom(value, obj , in_func , before)

func bsearch(value : MyRoom, before : bool = true):
	items.bsearch(value, before)

func back():
	items.back()

func append_array(array: MyRoomArray):
	items.append_array(array.items)

func append(value : MyRoom):
	items.append(value)
