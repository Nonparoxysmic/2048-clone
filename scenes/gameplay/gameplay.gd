extends Node

@export var item_template: PackedScene
var current_game_mode: Common.GameMode
var game_model: GameModel
var _items: ItemDictionary = ItemDictionary.new()
var _moves_made: int = 0
var _score: int = 0
var _game_ended: bool = false
var _prev_move_time: int = -1000
@onready var background: Node = %Background
@onready var item_parent: Node = %Items
@onready var counter: Counter = %Counter
@onready var game_over_label: Label = %GameOverLabel
@onready var debug_value: LineEdit = %DebugValue

func _ready() -> void:
	current_game_mode = GlobalData.game_mode
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
	connection_error = game_model.connect("move_completed", on_move_completed)
	if connection_error:
		var message: String = "Signal connection error in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")
		return
	if current_game_mode == Common.GameMode.CLASSIC:
		counter.initialize("Score", 0, false)
	elif current_game_mode == Common.GameMode.SWEET_SHOP:
		counter.initialize("Moves Remaining", 150, true)
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
		counter.update(_score)


func on_item_moved(id: int, x: int, y: int, fade: bool) -> void:
	if not _items.has(id):
		var message: String = "Invalid item ID in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")
		return
	_items.get_item(id).move_item(x, y, fade)


func on_move_completed() -> void:
	_prev_move_time = Time.get_ticks_msec()
	if current_game_mode == Common.GameMode.SWEET_SHOP:
		_moves_made += 1
		counter.update(150 - _moves_made)
		if _moves_made >= 150:
			_game_ended = true
	if game_model.no_moves_available():
		_game_ended = true
	if _game_ended:
		handle_game_end()


func spawn_item(id: int, type: Common.ItemType, x: int, y: int) -> Item:
	var instance: Item = item_template.instantiate() as Item
	if not instance:
		var message: String = "Invalid Item instance in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")
		return
	instance.name = "Item" + str(id)
	item_parent.add_child(instance)
	instance.set_sprite_textures(type)
	instance.position = Vector2(384 + 512 * x, 384 + 512 * y)
	instance.reveal()
	return instance


func handle_game_end() -> void:
	var text_tween: Tween = create_tween()
	text_tween.tween_property(game_over_label, "self_modulate", Color.WHITE, 0.25)
	if current_game_mode == Common.GameMode.CLASSIC:
		if HighScores.is_new_high_score(_score):
			HighScores.add_score_with_datetime(_score)
	elif current_game_mode == Common.GameMode.SWEET_SHOP:
		await get_tree().create_timer(2).timeout
		game_over_label.self_modulate = Color.TRANSPARENT
		var bg_tween: Tween = create_tween()
		bg_tween.tween_property(background, "modulate", Color.TRANSPARENT, 3.0)
		var current_ids: Array[int] = game_model.get_current_item_ids()
		for id: int in current_ids:
			if id > 0:
				_items.get_item(id).convert_to_reward()
		# TODO: add up rewards


func exit_to_main_menu() -> void:
	var parent: Main = get_parent() as Main
	if parent:
		parent.go_to_main_menu()


func debug_end_game() -> void:
	_game_ended = true
	handle_game_end()


func debug_set_score() -> void:
	_score = int(debug_value.text)
	debug_value.text = ""
	debug_value.release_focus()
	counter.update(_score)


func debug_set_moves() -> void:
	_moves_made = 150 - int(debug_value.text)
	debug_value.text = ""
	debug_value.release_focus()
	counter.update(150 - _moves_made)
	if _moves_made >= 150:
		_game_ended = true
		handle_game_end()


func debug_summon_item() -> void:
	var type: int = int(debug_value.text) % Common.ItemType.size()
	debug_value.text = ""
	debug_value.release_focus()
	game_model.debug_create_item(type)
