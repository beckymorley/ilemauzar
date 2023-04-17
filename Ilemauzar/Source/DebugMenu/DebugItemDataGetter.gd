extends Node

class_name DebugItemDataGetter

func print_values(debug_items):
	for item in debug_items.items:
		print("New Debug item: " + item.string_id + ", type: " + str(item.type) + ", default value: " + str(item.value))

func get_data() -> DebugItemArray:
	var debug_items = parse_debug_data_file()
	
	var data = DebugItemArray.new()
	for item in debug_items.items:
		data.push_back(item)
		
	print_values(data)
	return data
	
func parse_debug_data_file() -> Dictionary:
	var parse = JSONParse.new()
	var debug_data = parse.read_json_file("res://debug_item_data.json")
	var dictionary_parse = DictionaryParse.new()
	return dictionary_parse.parse_debug_data(debug_data)
