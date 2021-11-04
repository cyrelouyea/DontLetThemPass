extends Node2D

var mode = "duplicate"
var changing_mode = false
var delay_change_mode = 1.0

func _ready():
	pass

func _process(delta):
	delta = delta * Global.speed
	var mouse_pos = get_viewport().get_mouse_position()
	position.y = clamp(mouse_pos.y, 42, get_viewport_rect().size.y)	
	
	if changing_mode:
		delay_change_mode -= delta
		if delay_change_mode < 0:
			changing_mode = false
			if mode == "duplicate":
				$Duplicater.show()
				$Eraser.hide()
			elif mode == "erase":
				$Duplicater.hide()
				$Eraser.show()
				
	$KickDuplicater.pitch_scale = lerp($KickDuplicater.pitch_scale, 1 * Global.speed, delta * 8)
	$KickEraser.pitch_scale = lerp($KickDuplicater.pitch_scale, 1 * Global.speed, delta * 8)
	$LaunchEraser.pitch_scale = lerp($LaunchEraser.pitch_scale, 1 * Global.speed, delta * 8)

func shoot():
	if mode == "duplicate":
		$Duplicater.shoot()
		$KickDuplicater.play()
	elif mode == "erase":
		$KickEraser.play()
	
func set_mode(new_mode: String):
	mode = new_mode
	changing_mode = true
	if mode == "duplicate":
		delay_change_mode = 0.3
		$Eraser.activate(false)
	elif mode == "erase":
		delay_change_mode = 0.0
		$Eraser.activate(true)
		$LaunchEraser.play()
		
func reset():
	mode = "duplicate"
	$Duplicater.show()
	$Eraser.hide()
	$Eraser.activate(false)
	changing_mode = false
	delay_change_mode = 0.0
		
		
