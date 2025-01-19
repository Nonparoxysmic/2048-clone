class_name Item
extends Node2D

@export var sprite: Sprite2D

func _ready() -> void:
	if not sprite:
		var message: String = "Missing sprite reference in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")


func set_sprite_texture(type: Common.ItemType) -> void:
	sprite.texture = Stores.get_item_texture(type)


func set_hidden(do_hide: bool) -> void:
	if do_hide:
		sprite.self_modulate = Color(Color.WHITE, 0.0)
	else:
		sprite.self_modulate = Color(Color.WHITE, 1.0)
