extends Node

@export var item_template: PackedScene
var current_game_mode: Common.GameMode
var game_model: GameModel
var _items: ItemDictionary = ItemDictionary.new()
var _moves_made: int = 0
var _score: int = 0
var _game_ended: bool = false
var _prev_move_time: int = -1000
@onready var item_parent: Node = %Items
@onready var counter: Label = %CounterLabel
@onready var counterTitle: Label = %CounterTitleLabel

func _ready() -> void:
	current_game_mode = Stores.game_mode
	if not item_template:
		var message: String = "Missing item scene reference in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")
		return
	if not item_parent:
		var message: String = "Missing node reference in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")
		return
	game_model = GameModel.new()
	var connection_error: Error = game_model.connect("item_created", on_item_created)
	if connection_error:
		var message: String = "Signal connection error in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")
		return
	connection_error = game_model.connect("item_moved", on_item_moved)
	if connection_error:
		var message: String = "Signal connection error in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")
		return
	connection_error = game_model.connect("item_hidden", on_item_hidden)
	if connection_error:
		var message: String = "Signal connection error in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")
		return
	connection_error = game_model.connect("move_completed", on_move_completed)
	if connection_error:
		var message: String = "Signal connection error in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")
		return
	if current_game_mode == Common.GameMode.CLASSIC:
		counterTitle.text = "Score"
		counter.text = "0"
		counter.label_settings.font_size = 256
	elif current_game_mode == Common.GameMode.SWEET_SHOP:
		counterTitle.text = "Moves Remaining"
		counter.text = "150"
		counter.label_settings.font_size = 256
	game_model.start_game()


func _unhandled_key_input(event: InputEvent) -> void:
	if (Time.get_ticks_msec() < _prev_move_time + 250):
		return
	if not game_model.awaiting_input:
		return
	if _game_ended:
		return
	if event.is_action_pressed("ui_up"):
		game_model.handle_input(Common.Direction.UP)
	elif event.is_action_pressed("ui_down"):
		game_model.handle_input(Common.Direction.DOWN)
	elif event.is_action_pressed("ui_left"):
		game_model.handle_input(Common.Direction.LEFT)
	elif event.is_action_pressed("ui_right"):
		game_model.handle_input(Common.Direction.RIGHT)


func on_item_created(id: int, type: Common.ItemType, x: int, y: int, merge: bool) -> void:
	var created_item: Item = spawn_item(id, type, x, y)
	_items.set_item(id, created_item)
	if merge and current_game_mode == Common.GameMode.CLASSIC:
		_score += 2 ** type
		counter.text = Common.commas(_score)
		if _score > 999999:
			counter.label_settings.font_size = 192


func on_item_moved(id: int, x: int, y: int, fade: Common.Fade) -> void:
	if not _items.has(id):
		var message: String = "Invalid item ID in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")
		return
	_items.get_item(id).move_item(x, y, fade)


func on_item_hidden(id: int, hidden: bool) -> void:
	if not _items.has(id):
		var message: String = "Invalid item ID in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")
		return
	_items.get_item(id).set_hidden(hidden)


func on_move_completed() -> void:
	_prev_move_time = Time.get_ticks_msec()
	if current_game_mode == Common.GameMode.SWEET_SHOP:
		_moves_made += 1
		counter.text = str(150 - _moves_made)
		if _moves_made >= 150:
			_game_ended = true
	if game_model.no_moves_available():
		_game_ended = true
	if _game_ended:
		if current_game_mode == Common.GameMode.CLASSIC:
			if Stores.new_high_score(_score):
				Stores.add_score(Time.get_datetime_string_from_system(false, true), _score)
		# TODO: handle game end


func spawn_item(id: int, type: Common.ItemType, x: int, y: int) -> Item:
	var instance: Item = item_template.instantiate() as Item
	if not instance:
		var message: String = "Invalid Item instance in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")
		return
	instance.name = "Item" + str(id)
	item_parent.add_child(instance)
	instance.set_sprite_texture(type)
	instance.position = Vector2(384 + 512 * x, 384 + 512 * y)
	instance.set_hidden(false)
	return instance
