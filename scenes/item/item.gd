class_name Item
extends Node2D

signal points_scored(level: int, points: int)
@export var sprite: Sprite2D
@export var reward_sprite: Sprite2D
var item_type: Common.ItemType
var last_diagonal: int
var _slide_time: float = 0.25


func _ready() -> void:
	if not sprite or not reward_sprite:
		var message: String = "Missing sprite reference in node %s" % name
		printerr(message)
		OS.alert(message, "Error")


func set_sprite_textures(type: Common.ItemType) -> void:
	item_type = type
	sprite.texture = Textures.get_item_texture(type)
	reward_sprite.texture = Textures.get_reward_texture(type)


func move_item(x: int, y: int, fade: bool) -> void:
	last_diagonal = x + y
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


func move_and_score() -> void:
	var reward_level: int = Common.get_reward_level(item_type)
	if reward_level == 0:
		queue_free()
		return
	
	var tween: Tween = create_tween()
	var new_pos: Vector2 = Vector2(1920, 1152)
	tween.tween_property(self, "position", new_pos, _slide_time)
	tween.parallel() \
	.tween_property(reward_sprite, "scale", Vector2(0.5, 0.5), _slide_time)
	await tween.finished
	
	var points: int = Common.get_reward_quantity(item_type)
	points_scored.emit(reward_level, points)
	queue_free()
