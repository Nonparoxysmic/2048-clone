class_name Item
extends Node2D

@export var sprite: Sprite2D

func _ready() -> void:
	if not sprite:
		var message: String = "Missing sprite reference in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")


func set_sprite(type: Common.ItemType) -> void:
	sprite.texture = Stores.get_item_texture(type)
