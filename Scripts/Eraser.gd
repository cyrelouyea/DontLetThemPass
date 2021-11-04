extends Node2D

var dist_y = 0

func _ready():
	pass 

func _process(delta):
	delta = delta * Global.speed
	$LaserUp.position.y = lerp($LaserUp.position.y, -dist_y, delta*12)
	$LaserDown.position.y = lerp($LaserDown.position.y, dist_y, delta*12)
	$Effect.dist = $LaserUp.position.y

func activate(b: bool):
	if b:
		dist_y = 320
	else:
		dist_y = 0
