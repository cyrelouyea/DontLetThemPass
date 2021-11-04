extends Label

var _hi_score: float 

func _ready():
	pass

func _process(delta):
	text = "HIGH SCORE: " + str(int(_hi_score))
