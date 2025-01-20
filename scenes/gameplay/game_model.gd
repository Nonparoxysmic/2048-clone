class_name GameModel

signal item_created(id: int, type: Common.ItemType, x: int, y: int)
signal item_moved(id: int, x: int, y: int, fade: Common.Fade)
signal item_hidden(id: int, hidden: bool)
var awaiting_input: bool = true

var _next_id: int = 1
var _board: BoardModel = BoardModel.new()

func start_game() -> void:
	var start1: int = randi() % 16
	var start2: int = start1
	while start2 == start1:
		start2 = randi() % 16
	create_new_item(start1 % 4, start1 / 4)
	create_new_item(start2 % 4, start2 / 4)


func handle_input(direction: Common.Direction) -> void:
	awaiting_input = false
	if direction:
		if _board.can_move_direction(direction):
			# TODO: make move
			print("make move in direction ", direction)
	awaiting_input = true


func create_item(type: Common.ItemType, x: int, y: int) -> void:
	var id: int = _next_id
	_next_id += 1
	_board.set_item(id, type, x, y)
	item_created.emit(id, type, x, y)


func create_new_item(x: int, y: int) -> void:
	var is_berry: bool = randf() <= 0.9
	if is_berry:
		create_item(Common.ItemType.BERRY_2, x, y)
	else:
		create_item(Common.ItemType.JUICE_4, x, y)
