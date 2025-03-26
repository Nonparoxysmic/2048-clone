class_name GameModel

signal item_created(id: int, type: Common.ItemType, x: int, y: int, merge: bool)
signal item_moved(id: int, x: int, y: int, fade: bool)
signal move_completed()
var awaiting_input: bool = true

var _next_id: int = 1
var _board: BoardModel = BoardModel.new()

func start_game() -> void:
	create_new_item()
	create_new_item()


func handle_input(direction: Common.Direction) -> void:
	awaiting_input = false
	if _board.can_move_direction(direction):
		make_move(direction)
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


func make_move(direction: Common.Direction) -> void:
	if direction == Common.Direction.NONE:
		return
	
	# set up coordinates
	var para: Array[int] = [0, 1, 2, 3]
	var perp: Array[int] = [0, 1, 2, 3]
	var swap: bool = false
	if direction == Common.Direction.RIGHT:
		para.reverse()
	if direction == Common.Direction.DOWN:
		perp.reverse()
	if direction == Common.Direction.DOWN or direction == Common.Direction.UP:
		swap = true
		var temp: Array[int] = para
		para = perp
		perp = temp
	
	for v: int in perp:
		# for each line of motion
		
		# collect the positions, ids, and types of items
		var starts: Array[int] = []
		var ids: Array[int] = []
		var types: Array[Common.ItemType] = []
		for u: int in para:
			# check opposite the direction of motion
			var x: int = v if swap else u
			var y: int = u if swap else v
			if _board.get_item_id(x, y) > 0:
				starts.append(u)
				ids.append(_board.get_item_id(x, y))
				types.append(_board.get_item_type(x, y))
		
		# if there are no items, this line is done
		if ids.is_empty():
			continue
		
		# keep track of which items will merge
		var merges: Array[bool] = []
		for i: int in types.size():
			merges.append(false)
		if types.size() > 1:
			# mark the second item in each pair as merging
			for i: int in (types.size() - 1):
				if merges[i]:
					continue
				if types[i] == types[i + 1]:
					merges[i + 1] = true
			# mark the first item in each pair as merging
			for i: int in (ids.size() - 1):
				if merges[i + 1]:
					merges[i] = true
		
		# determine the moves
		for new: int in para:
			if ids.is_empty():
				# all items moved
				break
			var old: int = starts.pop_front()
			var id: int = ids.pop_front()
			var type: Common.ItemType = types.pop_front()
			var old_x: int = v if swap else old
			var old_y: int = old if swap else v
			var new_x: int = v if swap else new
			var new_y: int = new if swap else v
			if merges[0]:
				# item is merging
				# move and fade first item
				_board.remove_item(old_x, old_y)
				item_moved.emit(id, new_x, new_y, true)
				# move and fade second item
				merges.pop_front()
				old = starts.pop_front()
				id = ids.pop_front()
				type = types.pop_front()
				old_x = v if swap else old
				old_y = old if swap else v
				new_x = v if swap else new
				new_y = new if swap else v
				_board.remove_item(old_x, old_y)
				item_moved.emit(id, new_x, new_y, true)
				# spawn new item
				var new_type: Common.ItemType = ((type + 1) % Common.ItemType.size()) as Common.ItemType
				var new_id: int = create_item(new_type, new_x, new_y, true)
				_board.set_item(new_id, new_type, new_x, new_y)
			else:
				# item just slides
				_board.remove_item(old_x, old_y)
				_board.set_item(id, type, new_x, new_y)
				item_moved.emit(id, new_x, new_y, false)
			merges.pop_front()
	
	# after completing the player move, add a new item
	create_new_item()
