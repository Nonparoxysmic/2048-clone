class_name GameModel

signal item_created(id: int, type: Common.ItemType, x: int, y: int, merge: bool)
signal item_moved(id: int, x: int, y: int, fade: Common.Fade)
signal item_hidden(id: int, hidden: bool)
signal move_completed()
var awaiting_input: bool = true

var _next_id: int = 1
var _board: BoardModel = BoardModel.new()

func start_game() -> void:
	create_new_item()
	create_new_item()


func handle_input(direction: Common.Direction) -> void:
	awaiting_input = false
	if direction:
		if _board.can_move_direction(direction):
			match direction:
				Common.Direction.RIGHT:
					move_right()
				Common.Direction.DOWN:
					move_down()
				Common.Direction.LEFT:
					move_left()
				Common.Direction.UP:
					move_up()
			move_completed.emit()
	awaiting_input = true


func create_item(type: Common.ItemType, x: int, y: int, merge: bool) -> int:
	var id: int = _next_id
	_next_id += 1
	_board.set_item(id, type, x, y)
	item_created.emit(id, type, x, y, merge)
	return id


func create_new_item() -> int:
	var pos: Vector2i = _board.random_empty_position()
	var is_berry: bool = randf() <= 0.9
	if is_berry:
		return create_item(Common.ItemType.BERRY_2, pos.x, pos.y, false)
	else:
		return create_item(Common.ItemType.JUICE_4, pos.x, pos.y, false)


func debug_create_item(type: Common.ItemType) -> void:
	var pos: Vector2i = _board.random_empty_position()
	var new_id: int = create_item(type, pos.x, pos.y, false)
	_board.set_item(new_id, type, pos.x, pos.y)


func no_moves_available() -> bool:
	for dir: int in range(1, 5):
		if _board.can_move_direction(dir):
			return false
	return true


func get_current_item_ids() -> Array[int]:
	return _board.get_all_ids()


func move_right() -> void:
	# for each row
	for y: int in 4:
		# collect the positions, ids, and types of items
		var init_x: Array[int] = []
		var ids: Array[int] = []
		var types: Array[Common.ItemType] = []
		for x: int in range(3, -1, -1):
			# check from right to left
			if _board.get_item_id(x, y) > 0:
				init_x.append(x)
				ids.append(_board.get_item_id(x, y))
				types.append(_board.get_item_type(x, y))
		# if there are no items, this row is done
		if ids.is_empty():
			continue
		# determine which items will merge
		var merges: Array[bool] = []
		for i: int in ids.size():
			merges.append(false)
		if ids.size() > 1:
			# mark the second item in each pair as merging
			for i: int in (ids.size() - 1):
				if merges[i]:
					continue
				if types[i] == types[i + 1]:
					merges[i + 1] = true
		if merges.size() > 1:
			# mark the first item in each pair as merging
			for i: int in (ids.size() - 1):
				if merges[i + 1]:
					merges[i] = true
		# determine the moves
		for new_x: int in range(3, -1, -1):
			if ids.is_empty():
				# all items moved
				break
			if merges[0]:
				# item is merging
				# move and fade first item
				var old_x: int = init_x.pop_front()
				var id: int = ids.pop_front()
				var type: Common.ItemType = types.pop_front()
				merges.pop_front()
				_board.remove_item(old_x, y)
				item_moved.emit(id, new_x, y, Common.Fade.OUT)
				# move and fade second item
				old_x = init_x.pop_front()
				id = ids.pop_front()
				type = types.pop_front()
				merges.pop_front()
				_board.remove_item(old_x, y)
				item_moved.emit(id, new_x, y, Common.Fade.OUT)
				# spawn new item
				var new_type: Common.ItemType = ((type + 1) % Common.ItemType.size()) as Common.ItemType
				var new_id: int = create_item(new_type, new_x, y, true)
				_board.set_item(new_id, new_type, new_x, y)
			else:
				# item just slides
				var old_x: int = init_x.pop_front()
				var id: int = ids.pop_front()
				var type: Common.ItemType = types.pop_front()
				merges.pop_front()
				_board.remove_item(old_x, y)
				_board.set_item(id, type, new_x, y)
				item_moved.emit(id, new_x, y, Common.Fade.NONE)
	# after completing the player move, add a new item
	create_new_item()


func move_left() -> void:
	# for each row
	for y: int in 4:
		# collect the positions, ids, and types of items
		var init_x: Array[int] = []
		var ids: Array[int] = []
		var types: Array[Common.ItemType] = []
		for x: int in 4:
			# check from left to right
			if _board.get_item_id(x, y) > 0:
				init_x.append(x)
				ids.append(_board.get_item_id(x, y))
				types.append(_board.get_item_type(x, y))
		# if there are no items, this row is done
		if ids.is_empty():
			continue
		# determine which items will merge
		var merges: Array[bool] = []
		for i: int in ids.size():
			merges.append(false)
		if ids.size() > 1:
			# mark the second item in each pair as merging
			for i: int in (ids.size() - 1):
				if merges[i]:
					continue
				if types[i] == types[i + 1]:
					merges[i + 1] = true
		if merges.size() > 1:
			# mark the first item in each pair as merging
			for i: int in (ids.size() - 1):
				if merges[i + 1]:
					merges[i] = true
		# determine the moves
		for new_x: int in 4:
			if ids.is_empty():
				# all items moved
				break
			if merges[0]:
				# item is merging
				# move and fade first item
				var old_x: int = init_x.pop_front()
				var id: int = ids.pop_front()
				var type: Common.ItemType = types.pop_front()
				merges.pop_front()
				_board.remove_item(old_x, y)
				item_moved.emit(id, new_x, y, Common.Fade.OUT)
				# move and fade second item
				old_x = init_x.pop_front()
				id = ids.pop_front()
				type = types.pop_front()
				merges.pop_front()
				_board.remove_item(old_x, y)
				item_moved.emit(id, new_x, y, Common.Fade.OUT)
				# spawn new item
				var new_type: Common.ItemType = ((type + 1) % Common.ItemType.size()) as Common.ItemType
				var new_id: int = create_item(new_type, new_x, y, true)
				_board.set_item(new_id, new_type, new_x, y)
			else:
				# item just slides
				var old_x: int = init_x.pop_front()
				var id: int = ids.pop_front()
				var type: Common.ItemType = types.pop_front()
				merges.pop_front()
				_board.remove_item(old_x, y)
				_board.set_item(id, type, new_x, y)
				item_moved.emit(id, new_x, y, Common.Fade.NONE)
	# after completing the player move, add a new item
	create_new_item()


func move_down() -> void:
	# for each column
	for x: int in 4:
		# collect the positions, ids, and types of items
		var init_y: Array[int] = []
		var ids: Array[int] = []
		var types: Array[Common.ItemType] = []
		for y: int in range(3, -1, -1):
			# check from bottom to top
			if _board.get_item_id(x, y) > 0:
				init_y.append(y)
				ids.append(_board.get_item_id(x, y))
				types.append(_board.get_item_type(x, y))
		# if there are no items, this row is done
		if ids.is_empty():
			continue
		# determine which items will merge
		var merges: Array[bool] = []
		for i: int in ids.size():
			merges.append(false)
		if ids.size() > 1:
			# mark the second item in each pair as merging
			for i: int in (ids.size() - 1):
				if merges[i]:
					continue
				if types[i] == types[i + 1]:
					merges[i + 1] = true
		if merges.size() > 1:
			# mark the first item in each pair as merging
			for i: int in (ids.size() - 1):
				if merges[i + 1]:
					merges[i] = true
		# determine the moves
		for new_y: int in range(3, -1, -1):
			if ids.is_empty():
				# all items moved
				break
			if merges[0]:
				# item is merging
				# move and fade first item
				var old_y: int = init_y.pop_front()
				var id: int = ids.pop_front()
				var type: Common.ItemType = types.pop_front()
				merges.pop_front()
				_board.remove_item(x, old_y)
				item_moved.emit(id, x, new_y, Common.Fade.OUT)
				# move and fade second item
				old_y = init_y.pop_front()
				id = ids.pop_front()
				type = types.pop_front()
				merges.pop_front()
				_board.remove_item(x, old_y)
				item_moved.emit(id, x, new_y, Common.Fade.OUT)
				# spawn new item
				var new_type: Common.ItemType = ((type + 1) % Common.ItemType.size()) as Common.ItemType
				var new_id: int = create_item(new_type, x, new_y, true)
				_board.set_item(new_id, new_type, x, new_y)
			else:
				# item just slides
				var old_y: int = init_y.pop_front()
				var id: int = ids.pop_front()
				var type: Common.ItemType = types.pop_front()
				merges.pop_front()
				_board.remove_item(x, old_y)
				_board.set_item(id, type, x, new_y)
				item_moved.emit(id, x, new_y, Common.Fade.NONE)
	# after completing the player move, add a new item
	create_new_item()


func move_up() -> void:
	# for each column
	for x: int in 4:
		# collect the positions, ids, and types of items
		var init_y: Array[int] = []
		var ids: Array[int] = []
		var types: Array[Common.ItemType] = []
		for y: int in 4:
			# check from top to bottom
			if _board.get_item_id(x, y) > 0:
				init_y.append(y)
				ids.append(_board.get_item_id(x, y))
				types.append(_board.get_item_type(x, y))
		# if there are no items, this row is done
		if ids.is_empty():
			continue
		# determine which items will merge
		var merges: Array[bool] = []
		for i: int in ids.size():
			merges.append(false)
		if ids.size() > 1:
			# mark the second item in each pair as merging
			for i: int in (ids.size() - 1):
				if merges[i]:
					continue
				if types[i] == types[i + 1]:
					merges[i + 1] = true
		if merges.size() > 1:
			# mark the first item in each pair as merging
			for i: int in (ids.size() - 1):
				if merges[i + 1]:
					merges[i] = true
		# determine the moves
		for new_y: int in 4:
			if ids.is_empty():
				# all items moved
				break
			if merges[0]:
				# item is merging
				# move and fade first item
				var old_y: int = init_y.pop_front()
				var id: int = ids.pop_front()
				var type: Common.ItemType = types.pop_front()
				merges.pop_front()
				_board.remove_item(x, old_y)
				item_moved.emit(id, x, new_y, Common.Fade.OUT)
				# move and fade second item
				old_y = init_y.pop_front()
				id = ids.pop_front()
				type = types.pop_front()
				merges.pop_front()
				_board.remove_item(x, old_y)
				item_moved.emit(id, x, new_y, Common.Fade.OUT)
				# spawn new item
				var new_type: Common.ItemType = ((type + 1) % Common.ItemType.size()) as Common.ItemType
				var new_id: int = create_item(new_type, x, new_y, true)
				_board.set_item(new_id, new_type, x, new_y)
			else:
				# item just slides
				var old_y: int = init_y.pop_front()
				var id: int = ids.pop_front()
				var type: Common.ItemType = types.pop_front()
				merges.pop_front()
				_board.remove_item(x, old_y)
				_board.set_item(id, type, x, new_y)
				item_moved.emit(id, x, new_y, Common.Fade.NONE)
	# after completing the player move, add a new item
	create_new_item()
