extends Node

@export var item_template: PackedScene
var current_game_mode: Common.GameMode
var game_model: GameModel
var reward_points: Array[int] = []
var _items: ItemDictionary = ItemDictionary.new()
var _moves_made: int = 0
var _score: int = 0
var _game_ended: bool = false
var _prev_move_time: int = -1000
var _reward_point_visibility: int = 0
var _reward_point_labels: Array[Label]
@onready var background: Node = %Background
@onready var item_parent: Node = %Items
@onready var counter: Counter = %Counter
@onready var game_over_label: Label = %GameOverLabel
@onready var claim_button: TextureButton = %ClaimButton
@onready var debug_value: LineEdit = %DebugValue

func _ready() -> void:
	if not item_template:
		var message: String = "Missing item scene reference in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")
		return
	if not (background and item_parent and counter and game_over_label):
		var message: String = "Missing node reference in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")
		return
	
	current_game_mode = GlobalData.game_mode
	game_model = GameModel.new()
	reward_points.resize(5)
	_reward_point_labels = [
		null,
		%Points1Label,
		%Points2Label,
		%Points3Label,
		%Points4Label
	]
	
	var connection_error: int = game_model.item_created.connect(on_item_created)
	connection_error += game_model.item_moved.connect(on_item_moved)
	connection_error += game_model.move_completed.connect(on_move_completed)
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


func on_points_scored(level: int, points: int) -> void:
	# add up points
	reward_points[level] += points
	# update labels
	_reward_point_labels[level].text = Common.format_number(reward_points[level]) + "  "
	if level > _reward_point_visibility:
		for i: int in range(_reward_point_visibility + 1, level + 1):
			@warning_ignore("unsafe_property_access")
			_reward_point_labels[i].get_parent().visible = true
		_reward_point_visibility = level


func on_claim_button_pressed() -> void:
	claim_button.disabled = true
	var button_tween: Tween = get_tree().create_tween()
	button_tween.tween_property(claim_button, "self_modulate", Color.TRANSPARENT, 0.25)
	var labels: Array[Label] = [
		null,
		%Points1Label as Label,
		%Points2Label as Label,
		%Points3Label as Label,
		%Points4Label as Label,
	]
	var targets: Array[Vector2] = [
		Vector2.ZERO,
		Vector2.ZERO,
		Vector2(1920, 0),
		Vector2(3584, 0),
		Vector2(3584, 256),
	]
	for i: int in range(1, 5):
		var parent: Control = labels[i].get_parent()
		if parent.visible:
			parent.visible = false
			if reward_points[i]:
				var pos: Vector2 = labels[i].global_position - Vector2(384, 0)
				var reward: Item = spawn_reward(i, pos)
				reward.move_out_async(targets[i], 0.25, Vector2(0.75, 0.75))
		elif reward_points[i]:
			var message: String = "This shouldn't happen. (invisible points)"
			printerr(message)
			OS.alert(message, "Error")
	await get_tree().create_timer(0.5). timeout
	exit_to_main_menu()


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
	instance.last_diagonal = x + y
	instance.reveal()
	return instance


func spawn_reward(level: int, pos: Vector2) -> Item:
	var instance: Item = item_template.instantiate() as Item
	instance.name = "Reward" + str(level)
	item_parent.add_child(instance)
	instance.set_sprite_textures((level - 1) * 4 + 1)
	instance.position = pos
	instance.instant_reward()
	return instance


func handle_game_end() -> void:
	var text_tween: Tween = create_tween()
	text_tween.tween_property(game_over_label, "self_modulate", Color.WHITE, 0.25)
	if current_game_mode == Common.GameMode.CLASSIC:
		if HighScores.is_new_high_score(_score):
			HighScores.add_score_with_datetime(_score)
			# TODO: "New High Score" message
	elif current_game_mode == Common.GameMode.SWEET_SHOP:
		await get_tree().create_timer(2).timeout
		# fade out board
		game_over_label.self_modulate = Color.TRANSPARENT
		var bg_tween: Tween = create_tween()
		bg_tween.tween_property(background, "modulate", Color.TRANSPARENT, 3.0)
		# process rewards
		var final: Array[Item] = []
		for id: int in game_model.get_current_item_ids():
			final.append(_items.get_item(id))
		for item: Item in final:
			item.convert_to_reward()
		await get_tree().create_timer(1.5).timeout
		for i: int in range(0, 7):
			for reward: Item in final:
				if is_instance_valid(reward) and i == reward.last_diagonal:
					reward.points_scored.connect(on_points_scored)
					reward.move_and_score()
			if i == 4:
				var claim_tween: Tween = create_tween()
				claim_tween.tween_property(claim_button, "self_modulate", Color.WHITE, 2.5)
			await get_tree().create_timer(0.167).timeout
		if bg_tween.is_running():
			await bg_tween.finished
		claim_button.pressed.connect(on_claim_button_pressed)
		await get_tree().create_timer(0.167).timeout
		claim_button.disabled = false


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
	if type == 0:
		type = randi_range(1, Common.ItemType.size() - 1)
	debug_value.text = ""
	debug_value.release_focus()
	game_model.debug_create_item(type)
