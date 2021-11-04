extends Node2D

var slow_charge = 100.0
var max_charge = 100.0
var bar_effect_pos = 0.0

func _ready():
	pass 

func _process(delta):
	delta = delta  * Global.speed
	$Sprite2.region_rect.size.x = 108.0 * slow_charge / max_charge
	$Sprite2.material.set_shader_param("bar_effect_pos", bar_effect_pos - 0.5)
	
	if max_charge > slow_charge:
		bar_effect_pos = fmod(bar_effect_pos + delta, 2.0) 
	else:
		bar_effect_pos = fmod(bar_effect_pos + 5 * delta, 2.0) 

func reset():
	slow_charge = 100.0
