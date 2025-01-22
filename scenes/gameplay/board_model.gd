class_name BoardModel

var direction_vectors: Array[Vector2i] = [
	Vector2i(0, 0),
	Vector2i(1, 0),
	Vector2i(0, 1),
	Vector2i(-1, 0),
	Vector2i(0, -1),
]
var _ids: Array[int]
var _types: Array[Common.ItemType]

func _init() -> void:
	for i: int in 16:
		_ids.append(0)
		_types.append(Common.ItemType.NONE)


func get_item_id(x: int, y: int) -> int:
	return _ids[4 * y + x]


func get_item_type(x: int, y: int) -> Common.ItemType:
	return _types[4 * y + x]


func set_item(id: int, type: Common.ItemType, x: int, y: int) -> void:
	var i: int = 4 * y + x
	_ids[i] = id
	_types[i] = type


func remove_item(x: int, y: int) -> void:
	set_item(0, Common.ItemType.NONE, x, y)


func can_move_direction(direction: Common.Direction) -> bool:
	if direction == Common.Direction.NONE:
		return false
	for i: int in 16:
		var pos: Vector2i = Vector2i(i % 4, i / 4)
		if get_item_type(pos.x, pos.y) == Common.ItemType.NONE:
			continue
		var look: Vector2i = pos + direction_vectors[direction]
		if on_board(look):
			var empty: bool = get_item_type(look.x, look.y) == Common.ItemType.NONE
			var same: bool = get_item_type(look.x, look.y) == get_item_type(pos.x, pos.y)
			if empty or same:
				return true
	return false


func on_board(position: Vector2i) -> bool:
	if position.x < 0 or position.x > 3 or position.y < 0 or position.y > 3:
		return false
	return true


func random_empty_position() -> Vector2i:
	var empty: Array[Vector2i] = []
	for i: int in 16:
		var pos: Vector2i = Vector2i(i % 4, i / 4)
		if get_item_id(pos.x, pos.y) == 0:
			empty.append(Vector2i(pos.x, pos.y))
	var i: int = randi_range(0, empty.size() - 1)
	return empty[i]
