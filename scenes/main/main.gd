class_name Main
extends Node

@export var title_screen_scene: PackedScene
@export var main_menu_scene: PackedScene
@export var gameplay_scene: PackedScene


func _ready() -> void:
	if title_screen_scene:
		add_child(title_screen_scene.instantiate())
	elif main_menu_scene:
		add_child(main_menu_scene.instantiate())
	elif gameplay_scene:
		add_child(gameplay_scene.instantiate())
	else:
		var message: String = "No scene references in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")


func start_gameplay() -> void:
	get_child(0).queue_free()
	add_child(gameplay_scene.instantiate())
