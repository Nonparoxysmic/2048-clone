extends Control


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
