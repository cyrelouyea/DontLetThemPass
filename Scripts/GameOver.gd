extends Node2D


var cumul_delta = 0.0

func _process(delta):
	$GameOver/Press.modulate.a = 0.7 + 0.2 * cos(cumul_delta)
	cumul_delta += delta * 4
