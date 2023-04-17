extends Reference

class_name DictionaryParse

func parse_debug_data(dictionary : Dictionary, debug_item_array : DebugItemArray = null, parent_entry: DebugItem = null) -> DebugItemArray:
	var ItemType = DebugItemType.new()
	if debug_item_array == null:
		debug_item_array = DebugItemArray.new()
	
	var item_name : String
	var item_desc : String
	var type : int
	var default 
	var parent_id : String = ""
	var child_items_to_load : Array
	
	for key in dictionary.keys():
		if str(key) == "debug_items":
			var item_keys = dictionary.get(key)
			for item in item_keys:
				debug_item_array = parse_debug_data(item, debug_item_array)
			return debug_item_array
		else:			
			if(str(key) == "name"):
				item_name = dictionary.get(key)
			elif(str(key) == "description"):
				item_desc = dictionary.get(key)
			elif (str(key) == "type"):
				type = ItemType.get_type_int(dictionary.get(key))
			elif(str(key) == "default"):
				default = dictionary.get(key)
			elif(str(key) == "child_items"):
				child_items_to_load = dictionary.get(key)
			elif(str(key) == "parent_id"):
				parent_id = dictionary.get(key)
				
	var new_entry = DebugItem.new(item_name, item_desc, type, default, parent_id)
	debug_item_array.push_back(new_entry)
	
	if(child_items_to_load.size() > 0):
		for item in child_items_to_load: 
			parse_debug_data(item, debug_item_array, new_entry)
	
	#if(parent_entry):
		#parent_entry.add_child_item(new_entry)
	
	return debug_item_array
		
