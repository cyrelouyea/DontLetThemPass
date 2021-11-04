extends Node2D

var t = 0.0
var size = 0.0
var nb_lines = 7
var step = PI / nb_lines* 2
var dist = 0.0
var dest_dist = 250
var alpha = 1.0

func _ready():
	pass 

func _process(delta):
	if t > 3.0:
		queue_free()
	
	delta = delta * Global.speed
	dist = lerp(dist, dest_dist, delta*5)
	alpha = lerp(alpha, 0, delta*5)
	t += delta * 4	
	update()

func _draw():
	for i in range(nb_lines):
		draw_line(
			Vector2(0, dist * cos(t + i*step)),
			Vector2(1024, dist*1.5 * cos(t + i*step+0.5)),
			Color(1.0, 0.2, 0.2, alpha),
			3.0
		)
