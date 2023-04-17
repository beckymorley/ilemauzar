extends Reference

class_name DebugItemType

enum Type {
	TICKBOX,
	TEXT_INPUT_BUTTON
	TEXT_INPUT,
	BUTTON,
	TEXT_INPUT_STRUCT_BUTTON,
	ITEM_GROUP,
	NONE = -1
}

func get_type_int(string : String) -> int:
	return Type.get(string)

func get_type_str(index : int) -> String:
	return Type[index]

