class_name HighScore
extends HBoxContainer

@onready var name_label: Label = %NameLabel
@onready var score_label: Label = %ScoreLabel


func set_data(title: String, score: int) -> void:
	name_label.text = title
	score_label.text = Common.format_number(score)
