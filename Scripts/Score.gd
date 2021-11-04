extends Label

var _score: float
var hi_score: float 

func _ready():
	pass

func _process(delta):
	text = "SCORE: " + str(int(_score))

func add_score(score: float):
	_score += score

func reset():
	_score = 0.0
