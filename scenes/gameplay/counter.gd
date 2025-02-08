class_name Counter
extends Node2D

var _count: int
var _is_countdown: bool
var _default_color: Color = Color("483117")
var _danger_color: Color = Color("990000")
var _danger_tween: Tween
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
	#region Update Text
	count_label.text = Common.format_number(_count)
	count_label.label_settings.font_size = 192 if _count > 999999 else 256
	count_label.label_settings.font_color = \
		_danger_color if _is_countdown and _count < 6 else _default_color
	#endregion Update Text
	#region Animations
	# Create tweens
	var update_tween: Tween = create_tween()
	if not _danger_tween:
		_danger_tween = create_tween()
		_danger_tween.pause()
	# Update_Tween
	if _danger_tween.is_running() or (_is_countdown and _count < 6):
		update_tween.kill()
	else:
		update_tween.tween_property(count_label, "scale", Vector2(0.75, 0.75), 0.125)
		update_tween.tween_property(count_label, "scale", Vector2.ONE, 0.125)
	# Danger_Tween
	if _is_countdown and _count < 6:
		if _count == 0:
			_danger_tween.kill()
			count_label.scale = Vector2.ONE
		else:
			if update_tween.is_running():
				await update_tween.finished
			if not _danger_tween.is_running():
				_danger_tween.tween_property(count_label, "scale", Vector2(0.75, 0.75), 0.325)
				_danger_tween.tween_property(count_label, "scale", Vector2.ONE, 0.325)
				_danger_tween.set_loops()
				_danger_tween.play()
	#endregion Animations
