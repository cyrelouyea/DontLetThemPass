extends Node2D

var scale_y = 1.5
var n_scale_y = 1.5
var d_scale_y = 0

func _ready():
	pass

func _process(delta):
	delta = delta * Global.speed
	$LaserGreen.scale.y = scale_y + 0.5 * cos(d_scale_y)
	scale_y = lerp(scale_y, n_scale_y, delta * 5)
	d_scale_y += delta * 10
	
	
func shoot():
	scale_y = 6.0
