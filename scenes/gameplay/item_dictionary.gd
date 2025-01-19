class_name ItemDictionary
## Wrapper around Dictionary to contain unsafe lines.

var _items: Dictionary = {}

func has(key: int) -> bool:
	return _items.has(key)


func get_item(key: int) -> Item:
	return _items[key]


func set_item(key: int, value: Item) -> void:
	_items[key] = value
