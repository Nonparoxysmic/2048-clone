extends Node
## global autoload

var _item_textures: Array[Texture2D]
var _reward_textures: Array[Texture2D]


func _ready() -> void:
	_item_textures = [
		load("res://assets/sprites/missing_item_texture.png") as Texture2D,
		load("res://assets/sprites/placeholder/berry.png") as Texture2D,
		load("res://assets/sprites/placeholder/juice.png") as Texture2D,
		load("res://assets/sprites/placeholder/cookie.png") as Texture2D,
		load("res://assets/sprites/placeholder/tart.png") as Texture2D,
		load("res://assets/sprites/placeholder/cake1.png") as Texture2D,
		load("res://assets/sprites/placeholder/cake2.png") as Texture2D,
		load("res://assets/sprites/placeholder/cake3.png") as Texture2D,
		load("res://assets/sprites/placeholder/package.png") as Texture2D,
		load("res://assets/sprites/placeholder/ice_cream.png") as Texture2D,
		load("res://assets/sprites/placeholder/sundae.png") as Texture2D,
		load("res://assets/sprites/placeholder/banana_split.png") as Texture2D,
		# TODO: add missing textures
		load("res://assets/sprites/missing_item_texture.png") as Texture2D,
		load("res://assets/sprites/missing_item_texture.png") as Texture2D,
		load("res://assets/sprites/missing_item_texture.png") as Texture2D,
		load("res://assets/sprites/missing_item_texture.png") as Texture2D,
		load("res://assets/sprites/missing_item_texture.png") as Texture2D,
		load("res://assets/sprites/missing_item_texture.png") as Texture2D,
	]
	for texture: Texture2D in _item_textures:
		if not texture:
			var message: String = "Invalid item texture in node %s" % name
			printerr(message)
			OS.alert(message, "Error")
	_reward_textures = [
		load("res://assets/sprites/missing_item_texture.png") as Texture2D,
		load("res://assets/sprites/placeholder/rewards/star1.png") as Texture2D,
		load("res://assets/sprites/placeholder/rewards/star2.png") as Texture2D,
		load("res://assets/sprites/placeholder/rewards/star3.png") as Texture2D,
		load("res://assets/sprites/placeholder/rewards/star4.png") as Texture2D,
		load("res://assets/sprites/placeholder/rewards/bolt1.png") as Texture2D,
		load("res://assets/sprites/placeholder/rewards/bolt2.png") as Texture2D,
		load("res://assets/sprites/placeholder/rewards/bolt3.png") as Texture2D,
		load("res://assets/sprites/placeholder/rewards/bolt4.png") as Texture2D,
		load("res://assets/sprites/placeholder/rewards/heart1.png") as Texture2D,
		load("res://assets/sprites/placeholder/rewards/heart2.png") as Texture2D,
		load("res://assets/sprites/placeholder/rewards/heart3.png") as Texture2D,
		load("res://assets/sprites/placeholder/rewards/heart4.png") as Texture2D,
		load("res://assets/sprites/placeholder/rewards/paw1.png") as Texture2D,
		load("res://assets/sprites/placeholder/rewards/paw2.png") as Texture2D,
		load("res://assets/sprites/placeholder/rewards/paw3.png") as Texture2D,
		load("res://assets/sprites/placeholder/rewards/paw4.png") as Texture2D,
	]
	for texture: Texture2D in _reward_textures:
		if not texture:
			var message: String = "Invalid reward texture in node %s" % name
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
		Common.ItemType.ICE_CREAM_CONE_512:
			return _item_textures[9]
		Common.ItemType.SUNDAE_1024:
			return _item_textures[10]
		Common.ItemType.BANANA_SPLIT_2048:
			return _item_textures[11]
		Common.ItemType.ULTIMATE_ICE_CREAM_4096:
			return _item_textures[12]
		Common.ItemType.WRAPPED_CANDY_8192:
			return _item_textures[13]
		Common.ItemType.LOLLIPOP_16_384:
			return _item_textures[14]
		Common.ItemType.CANDY_CANE_32_768:
			return _item_textures[15]
		Common.ItemType.PB_CUP_65_536:
			return _item_textures[16]
		Common.ItemType.MAXIMUM_131_072:
			return _item_textures[17]
		_:
			return _item_textures[0]


func get_reward_texture(type: Common.ItemType) -> Texture2D:
	match type:
		Common.ItemType.NONE:
			return _reward_textures[0]
		Common.ItemType.BERRY_2:
			return _reward_textures[1]
		Common.ItemType.JUICE_4:
			return _reward_textures[2]
		Common.ItemType.COOKIE_8:
			return _reward_textures[3]
		Common.ItemType.TART_16:
			return _reward_textures[4]
		Common.ItemType.CAKE_PLAIN_32:
			return _reward_textures[5]
		Common.ItemType.CAKE_FROSTED_64:
			return _reward_textures[6]
		Common.ItemType.CAKE_DECORATED_128:
			return _reward_textures[7]
		Common.ItemType.PACKAGE_256:
			return _reward_textures[8]
		Common.ItemType.ICE_CREAM_CONE_512:
			return _reward_textures[9]
		Common.ItemType.SUNDAE_1024:
			return _reward_textures[10]
		Common.ItemType.BANANA_SPLIT_2048:
			return _reward_textures[11]
		Common.ItemType.ULTIMATE_ICE_CREAM_4096:
			return _reward_textures[12]
		Common.ItemType.WRAPPED_CANDY_8192:
			return _reward_textures[13]
		Common.ItemType.LOLLIPOP_16_384:
			return _reward_textures[14]
		Common.ItemType.CANDY_CANE_32_768:
			return _reward_textures[15]
		_:
			return _reward_textures[16]
