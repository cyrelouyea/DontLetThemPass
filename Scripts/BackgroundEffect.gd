extends Node2D

var t = 0.0
var nb_lines = 1000
var step = 0.01
var offset = 0.0

func _ready():
	pass

func _process(delta): 
	delta = delta * Global.speed
	t += delta * 0.5
	offset += delta
	update()

func _draw():
	for i in range(nb_lines):
		draw_line(
			Vector2(512.0 + 200.0 * x(t+step*i), 300.0 + 200.0 * y(t+step*i)),
			Vector2(512.0 + 200.0 * x(t+step*(i+1)), 300.0 + 200.0 * y(t+step*(i+1))), 
			Color(1.0, 0.0, 0.0, 0.2), 
			1
		)
		

func x(t: float):
	return 2*cos(t) + sin(2*t)*cos(60*t+offset)
	
func y(t: float):
	return sin(2*t) + sin(60*t)
