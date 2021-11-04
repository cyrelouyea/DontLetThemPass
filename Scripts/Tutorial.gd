extends Node2D

var timer = 0

func _process(delta):
	delta = delta * Global.speed
	if timer < 2.0:
		$mouse.position.y = lerp($mouse.position.y, -30, delta)
	elif timer < 4.0:
		$mouse.position.y = lerp($mouse.position.y, 30, delta)
	else:
		timer = 0.0
	timer += delta

