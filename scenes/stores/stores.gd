extends Node

var _item_textures: Array[Texture2D]

func _ready() -> void:
	_item_textures = [
		Texture2D.new(), # TODO: missing texture
		load("res://assets/sprites/placeholder/berry.png") as Texture2D,
		load("res://assets/sprites/placeholder/juice.png") as Texture2D,
		load("res://assets/sprites/placeholder/cookie.png") as Texture2D,
		load("res://assets/sprites/placeholder/tart.png") as Texture2D,
		load("res://assets/sprites/placeholder/cake1.png") as Texture2D,
		load("res://assets/sprites/placeholder/cake2.png") as Texture2D,
		load("res://assets/sprites/placeholder/cake3.png") as Texture2D,
		load("res://assets/sprites/placeholder/package.png") as Texture2D,
	]
	for texture: Texture2D in _item_textures:
		if not texture:
			var message: String = "Invalid texture in node " + name + "."
			printerr(message)
			OS.alert(message, "Error")


func get_item_texture(type: Common.ItemType) -> Texture2D:
	match type:
		Common.ItemType.BERRY_2:
			return _item_textures[1]
		Common.ItemType.JUICE_4:
			return _item_textures[2]
		Common.ItemType.COOKIE_8:
			return _item_textures[3]
		Common.ItemType.TART_16:
			return _item_textures[4]
		Common.ItemType.CAKE_PLAIN_32:
			return _item_textures[5]
		Common.ItemType.CAKE_FROSTED_64:
			return _item_textures[6]
		Common.ItemType.CAKE_DECORATED_128:
			return _item_textures[7]
		Common.ItemType.PACKAGE_256:
			return _item_textures[8]
		_:
			return _item_textures[0]
