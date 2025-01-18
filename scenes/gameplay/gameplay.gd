extends Node

@export var item_template: PackedScene
var game_model: GameModel
@onready var item_parent: Node = get_node("%Items")

func _ready() -> void:
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
	game_model.start_game()


func _unhandled_key_input(event: InputEvent) -> void:
	if not game_model.awaiting_input:
		return
	if event.is_action_pressed("ui_up"):
		game_model.handle_input(Common.Direction.UP)
	elif event.is_action_pressed("ui_down"):
		game_model.handle_input(Common.Direction.DOWN)
	elif event.is_action_pressed("ui_left"):
		game_model.handle_input(Common.Direction.LEFT)
	elif event.is_action_pressed("ui_right"):
		game_model.handle_input(Common.Direction.RIGHT)


func on_item_created(id: int, type: Common.ItemType, x: int, y: int) -> void:
	# TODO
	print("item created, id %d, type %d, pos (%d, %d)" % [id, type, x, y])
	spawn_item(type, x, y)


func on_item_moved(id: int, x: int, y: int, fade: Common.Fade) -> void:
	# TODO
	print("item moved, id %d, pos (%d, %d), fade %d" % [id, x, y, fade])


func on_item_hidden(id: int, hidden: bool) -> void:
	# TODO
	print("item hidden, id %d, hidden %s" %[id, hidden])


func spawn_item(type: Common.ItemType, x: int, y: int) -> void:
	var instance: Item = item_template.instantiate() as Item
	if not instance:
		var message: String = "Invalid Item instance in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")
		return
	item_parent.add_child(instance)
	instance.set_sprite_texture(type)
	instance.position = Vector2(384 + 512 * x, 384 + 512 * y)
