class_name Item
extends Node2D

@export var sprite: Sprite2D
var _slide_time: float = 0.25

func _ready() -> void:
	if not sprite:
		var message: String = "Missing sprite reference in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")


func set_sprite_texture(type: Common.ItemType) -> void:
	sprite.texture = Stores.get_item_texture(type)


func move_item(x: int, y: int, fade: Common.Fade) -> void:
	var tween: Tween = create_tween()
	var new_pos: Vector2 = Vector2(384 + 512 * x, 384 + 512 * y)
	tween.tween_property(self, "position", new_pos, _slide_time)
	if fade == Common.Fade.IN:
		tween.parallel().tween_property(sprite, "self_modulate", Color.WHITE, _slide_time)
	elif fade == Common.Fade.OUT:
		tween.parallel().tween_property(sprite, "self_modulate", Color.TRANSPARENT, _slide_time)


func set_hidden(do_hide: bool) -> void:
	# TODO: animate
	if do_hide:
		sprite.self_modulate = Color.TRANSPARENT
	else:
		sprite.self_modulate = Color.WHITE
