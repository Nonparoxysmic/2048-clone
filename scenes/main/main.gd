class_name Main
extends Node

@export var title_screen_scene: PackedScene
@export var main_menu_scene: PackedScene
@export var gameplay_scene: PackedScene
var current: Node


func _ready() -> void:
	if title_screen_scene:
		current = title_screen_scene.instantiate()
		add_child(current)
	elif main_menu_scene:
		current = main_menu_scene.instantiate()
		add_child(current)
	elif gameplay_scene:
		gameplay_scene.instantiate()
		add_child(current)
	else:
		var message: String = "No scene references in node " + name + "."
		printerr(message)
		OS.alert(message, "Error")


func start_gameplay() -> void:
	current.queue_free()
	current = gameplay_scene.instantiate()
	add_child(current)


func go_to_main_menu() -> void:
	current.queue_free()
	current = main_menu_scene.instantiate()
	add_child(current)
