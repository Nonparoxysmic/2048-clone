extends Node
## global autoload

var _high_score_filename: String = "user://high_scores.save"
var _high_scores: Array[int]
var _high_score_titles: Array[String]


func _ready() -> void:
	_high_scores = []
	_high_scores.resize(10)
	_high_score_titles = []
	_high_score_titles.resize(10)
	_load_high_scores()


func is_new_high_score(score: int) -> bool:
	return score > _high_scores[9]


func add_score(title: String, score: int) -> void:
	if score <= _high_scores[9]:
		return
	for i: int in range(8, -1, -1):
		if score <= _high_scores[i]:
			_high_scores.insert(i + 1, score)
			_high_score_titles.insert(i + 1, title)
			_high_scores.pop_back()
			_high_score_titles.pop_back()
			_save_high_scores()
			return
	_high_scores.push_front(score)
	_high_scores.pop_back()
	_high_score_titles.push_front(title)
	_high_score_titles.pop_back()
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
	var titles: Array = json.data["titles"]
	for i: int in range(10):
		_high_scores[i] = int(str(scores[i]))
		_high_score_titles[i] = str(titles[i])


func _save_high_scores() -> void:
	var save_file: FileAccess = FileAccess.open(_high_score_filename, FileAccess.WRITE)
	var data: Dictionary = {
		"titles": _high_score_titles,
		"scores": _high_scores
	}
	var json_string: String = JSON.stringify(data)
	save_file.store_line(json_string)
