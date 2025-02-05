extends Node
## global autoload

var game_mode: Common.GameMode
var _item_textures: Array[Texture2D]
var _high_score_filename: String = "user://high_scores.save"
var _high_scores: Array[int]
var _high_score_names: Array[String]

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
	]
	for texture: Texture2D in _item_textures:
		if not texture:
			var message: String = "Invalid texture in node " + name + "."
			printerr(message)
			OS.alert(message, "Error")
	_high_scores = []
	_high_scores.resize(10)
	_high_score_names = []
	_high_score_names.resize(10)
	_load_high_scores()


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
		_:
			return _item_textures[0]


func new_high_score(score: int) -> bool:
	return score > _high_scores[9]


func add_score(title: String, score: int) -> void:
	if score <= _high_scores[9]:
		return
	for i: int in range(8, -1, -1):
		if score <= _high_scores[i]:
			_high_scores.insert(i + 1, score)
			_high_score_names.insert(i + 1, title)
			_high_scores.pop_back()
			_high_score_names.pop_back()
			_save_high_scores()
			return
	_high_scores.push_front(score)
	_high_scores.pop_back()
	_high_score_names.push_front(title)
	_high_score_names.pop_back()
	_save_high_scores()


func _load_high_scores() -> void:
	if not FileAccess.file_exists(_high_score_filename):
		return
	var save_file: FileAccess = FileAccess.open(_high_score_filename, FileAccess.READ)
	var json_string: String = save_file.get_line()
	var json: JSON = JSON.new()
	var parse_error: Error = json.parse(json_string)
	if parse_error:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	var scores: Array = json.data["scores"]
	var names: Array = json.data["names"]
	for i: int in range(10):
		_high_scores[i] = int(str(scores[i]))
		_high_score_names[i] = str(names[i])


func _save_high_scores() -> void:
	var save_file: FileAccess = FileAccess.open(_high_score_filename, FileAccess.WRITE)
	var data: Dictionary = {
		"names": _high_score_names,
		"scores": _high_scores
	}
	var json_string: String = JSON.stringify(data)
	save_file.store_line(json_string)
