extends Control

@export var high_score: PackedScene
@onready var main_buttons: VBoxContainer = %MainButtons
@onready var high_scores: VBoxContainer = %HighScores
@onready var high_score_container: VBoxContainer = %HighScoreContainer


func _ready() -> void:
	if not high_score:
		return
	for i: int in 10:
		if Stores._high_scores[i] > 0:
			var node: HighScore = high_score.instantiate()
			high_score_container.add_child(node)
			node.set_data(Stores._high_score_names[i], Stores._high_scores[i])


func _start_game() -> void:
	var parent: Main = get_parent() as Main
	if parent:
		parent.start_gameplay()


func _on_sweet_shop_button_pressed() -> void:
	Stores.game_mode = Common.GameMode.SWEET_SHOP
	_start_game()


func _on_classic_button_pressed() -> void:
	Stores.game_mode = Common.GameMode.CLASSIC
	_start_game()


func _on_high_scores_button_pressed() -> void:
	main_buttons.visible = false
	high_scores.visible = true


func _on_high_scores_back_button_pressed() -> void:
	main_buttons.visible = true
	high_scores.visible = false
