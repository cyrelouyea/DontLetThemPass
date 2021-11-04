extends Node2D

var nb_lines = 80
var dist: float
var t: float
var step = 2*PI/nb_lines

func _ready():
	pass
	
func _process(delta):
	delta = delta * Global.speed
	t += delta * 0.1
	update()
	
func _draw():
	for i in range(nb_lines):
		draw_line(
			Vector2(-512, dist * cos(t + i * step)),
			Vector2(512, dist * cos(t + i * step)),
			Color(1.0, 0.0, 0.0, 0.3),
			5
		)
	
