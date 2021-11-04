extends Node2D


var offset = 0

func _ready():
	pass
	
func _process(delta):
	offset +=  2 * delta * Global.speed
	update()
	
func _draw():
	for i in range(20):
		draw_line(
			Vector2(0, 42 +  i*abs(cos(i+offset))), 
			Vector2(1024, 42 + i*abs(cos(i+offset))), 
			Color(1.0, 0.0, 0.0, 0.4), 
			1
		)
		
	for i in range(20):
		draw_line(
			Vector2(0, 600 - i*abs(cos(i+offset))), 
			Vector2(1024, 600 - i*abs(cos(i+offset))), 
			Color(1.0, 0.0, 0.0, 0.4), 
			1
		)
	
