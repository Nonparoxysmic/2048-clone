class_name Counter
extends Node2D

var _count: int
var _is_countdown: bool
var _default_color: Color = Color("483117")
var _danger_color: Color = Color.DARK_RED # TODO: pick a color
@onready var title_label: Label = %TitleLabel
@onready var count_label: Label = %NumberLabel


func initialize(title: String, count: int, is_countdown: bool) -> void:
	title_label.text = title
	_count = count
	_is_countdown = is_countdown
	_update()


func update(count: int) -> void:
	if count < 0:
		return
	_count = count
	_update()


func _update() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(count_label, "scale", Vector2(0.75, 0.75), 0.125)
	tween.tween_property(count_label, "scale", Vector2.ONE, 0.125)
	count_label.text = Common.format_number(_count)
	if _count > 999999:
		count_label.label_settings.font_size = 192
	else:
		count_label.label_settings.font_size = 256
	if _is_countdown and _count < 6:
		count_label.label_settings.font_color = _danger_color
	else:
		count_label.label_settings.font_color = _default_color
	if _is_countdown and 0 < _count and _count < 6:
		await tween.finished
		# TODO: animation
		pass
