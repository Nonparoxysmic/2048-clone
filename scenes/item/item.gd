class_name Item
extends Node2D

@export var sprite: Sprite2D
@export var reward_sprite: Sprite2D
var _slide_time: float = 0.25


func _ready() -> void:
	if not sprite or not reward_sprite:
		var message: String = "Missing sprite reference in node %s" % name
		printerr(message)
		OS.alert(message, "Error")


func set_sprite_textures(type: Common.ItemType) -> void:
	sprite.texture = Textures.get_item_texture(type)
	reward_sprite.texture = Textures.get_reward_texture(type)


func move_item(x: int, y: int, fade: bool) -> void:
	var tween: Tween = create_tween()
	var new_pos: Vector2 = Vector2(384 + 512 * x, 384 + 512 * y)
	tween.tween_property(self, "position", new_pos, _slide_time)
	if fade:
		tween.parallel() \
		.tween_property(sprite, "self_modulate", Color.TRANSPARENT, _slide_time)
		await tween.finished
		queue_free()


func reveal() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "self_modulate", Color.WHITE, _slide_time)
	var tween2: Tween = create_tween()
	tween2.set_ease(Tween.EASE_OUT)
	tween2.set_trans(Tween.TRANS_ELASTIC)
	tween2.tween_property(sprite, "scale", Vector2.ONE, _slide_time * 4)


func convert_to_reward() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "self_modulate", Color.TRANSPARENT, _slide_time)
	tween.parallel() \
	.tween_property(reward_sprite, "self_modulate", Color.WHITE, _slide_time)
	var tween2: Tween = create_tween()
	tween2.set_ease(Tween.EASE_OUT)
	tween2.set_trans(Tween.TRANS_ELASTIC)
	tween2.tween_property(reward_sprite, "scale", Vector2.ONE, _slide_time * 4)
