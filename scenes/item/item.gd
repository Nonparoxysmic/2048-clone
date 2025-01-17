class_name Item
extends Node2D

@export var sprite: Sprite2D

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func set_sprite(type: Common.ItemType) -> void:
	match type:
		Common.ItemType.BERRY_2:
			sprite.texture = load("res://assets/sprites/placeholder/berry.png")
		Common.ItemType.JUICE_4:
			sprite.texture = load("res://assets/sprites/placeholder/juice.png")
		Common.ItemType.COOKIE_8:
			sprite.texture = load("res://assets/sprites/placeholder/cookie.png")
		Common.ItemType.TART_16:
			sprite.texture = load("res://assets/sprites/placeholder/tart.png")
		Common.ItemType.CAKE_PLAIN_32:
			sprite.texture = load("res://assets/sprites/placeholder/cake1.png")
		Common.ItemType.CAKE_FROSTED_64:
			sprite.texture = load("res://assets/sprites/placeholder/cake2.png")
		Common.ItemType.CAKE_DECORATED_128:
			sprite.texture = load("res://assets/sprites/placeholder/cake3.png")
		Common.ItemType.PACKAGE_256:
			sprite.texture = load("res://assets/sprites/placeholder/package.png")
		_:
			printerr("no texture")
