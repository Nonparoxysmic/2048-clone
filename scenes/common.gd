class_name Common

enum Direction{
	NONE,
	RIGHT,
	DOWN,
	LEFT,
	UP,
}

enum GameMode{
	CLASSIC,
	SWEET_SHOP
}

enum ItemType {
	NONE,
	BERRY_2,
	JUICE_4,
	COOKIE_8,
	TART_16,
	CAKE_PLAIN_32,
	CAKE_FROSTED_64,
	CAKE_DECORATED_128,
	PACKAGE_256,
	ICE_CREAM_CONE_512,
	SUNDAE_1024,
	BANANA_SPLIT_2048,
	ULTIMATE_ICE_CREAM_4096,
	WRAPPED_CANDY_8192,
	LOLLIPOP_16_384,
	CANDY_CANE_32_768,
	PB_CUP_65_536,
	MAXIMUM_131_072,
}


static func format_number(input: int) -> String:
	var string: String = str(input)
	var mod: int = string.length() % 3
	var result: String = ""
	for i: int in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			result += ","
		result += string[i]
	return result


static func linear_curve(target: Vector2) -> Curve2D:
	var curve: Curve2D = Curve2D.new()
	curve.add_point(Vector2(0, 0))
	curve.add_point(target)
	return curve


static func parabolic_curve(target: Vector2, steps: int = 10) -> Curve2D:
	var curve: Curve2D = Curve2D.new()
	var a: float = target.y / pow(target.x, 2.0)
	for i: int in range(0, steps):
		var x: float = i * target.x / steps
		var y: float = a * pow(x, 2.0)
		curve.add_point(Vector2(x, y))
	curve.add_point(target)
	return curve


static func get_reward_level(item_type: ItemType) -> int:
	if item_type < 13:
		return (item_type + 3) / 4
	return 4


static func get_reward_quantity(item_type: ItemType) -> int:
	match item_type:
		Common.ItemType.NONE:
			return 0
		Common.ItemType.BERRY_2:
			return 5
		Common.ItemType.JUICE_4:
			return 10
		Common.ItemType.COOKIE_8:
			return 20
		Common.ItemType.TART_16:
			return 50
		Common.ItemType.CAKE_PLAIN_32:
			return 3
		Common.ItemType.CAKE_FROSTED_64:
			return 7
		Common.ItemType.CAKE_DECORATED_128:
			return 15
		Common.ItemType.PACKAGE_256:
			return 40
		Common.ItemType.ICE_CREAM_CONE_512:
			return 1
		Common.ItemType.SUNDAE_1024:
			return 4
		Common.ItemType.BANANA_SPLIT_2048:
			return 10
		Common.ItemType.ULTIMATE_ICE_CREAM_4096: 
			return 30
		_:
			@warning_ignore("narrowing_conversion")
			return pow(4, item_type - 10)
