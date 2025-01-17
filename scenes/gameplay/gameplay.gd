extends Node

@export var item_template: PackedScene
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
	
	# testing
	spawn_item(Common.ItemType.BERRY_2, 0, 0)
	spawn_item(Common.ItemType.JUICE_4, 1, 0)
	spawn_item(Common.ItemType.COOKIE_8, 2, 0)
	spawn_item(Common.ItemType.TART_16, 3, 0)
	spawn_item(Common.ItemType.CAKE_PLAIN_32, 3, 1)
	spawn_item(Common.ItemType.CAKE_FROSTED_64, 3, 2)
	spawn_item(Common.ItemType.CAKE_DECORATED_128, 3, 3)
	spawn_item(Common.ItemType.PACKAGE_256, 2, 3)


func spawn_item(type: Common.ItemType, x: int, y: int) -> void:
	var instance: Item = item_template.instantiate() as Item
	if not instance:
		var message: String = "Invalid Item instance in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")
		return
	item_parent.add_child(instance)
	instance.set_sprite(type)
	instance.position = Vector2(384 + 512 * x, 384 + 512 * y)
