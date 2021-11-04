

extends Node2D



var eraser_charge = 0
var eraser_level = 0
var bar_effect_pos = 0

func _ready():
	pass 

func _process(delta):
	delta = delta * Global.speed
	$Sprite2.region_rect.size.x = lerp($Sprite2.region_rect.size.x, 108.0 * eraser_charge / max_eraser_charge(), delta * 6)
	$Sprite2.material.set_shader_param("bar_effect_pos", bar_effect_pos - 0.5)
	
	if max_eraser_charge() > eraser_charge:
		bar_effect_pos = fmod(bar_effect_pos + delta, 2.0) 
	else:
		bar_effect_pos = fmod(bar_effect_pos + 5 * delta, 2.0) 
		
func max_eraser_charge():
	return int(8 + 2 * eraser_level)
	
func reset():
	eraser_charge = 0
	eraser_level = 0
