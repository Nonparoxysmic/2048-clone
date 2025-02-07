class_name Common

enum Direction{
	NONE,
	RIGHT,
	DOWN,
	LEFT,
	UP,
}

enum Fade{
	NONE,
	OUT,
	IN,
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
