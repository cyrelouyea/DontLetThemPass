extends Node2D

signal end_game

export var ball_sc: PackedScene
export var death_sc: PackedScene

onready var energy_bar = $Control/EnergyBar

var balls = []
var balls_to_add = []
var balls_to_erase = []
var ball_radius = 20
var shake_time = 0
var mode = "duplicate"
var cst_reload_time = 0.2
var reload_time = 0.0
var gray_scale = 0.0
var reload_slow = 0.0
var start_game = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	start_game = false
	
func _reset_all():
	balls.clear()
	balls_to_erase.clear()
	balls_to_add.clear()
	mode = "duplicate"
	$Laser.reset()
	$Control/EnergyBar.reset()
	$Control/SlowBar.reset()
	$Control/Score.reset()
	
func _process(delta):
	delta = delta * Global.speed
	
	$Camera2D/CanvasLayer/ColorRect.material.set_shader_param("gray_scale", gray_scale)
	
	if shake_time > 0:
		$Camera2D/CanvasLayer/ColorRect.material.set_shader_param("ampl", (shake_time/0.2) * 0.01 * (1+energy_bar.eraser_level/100.0) * cos(shake_time * 100))
		shake_time -= delta
		if shake_time <= 0:
			$Camera2D/CanvasLayer/ColorRect.material.set_shader_param("ampl", 0)
			
	if !start_game:
		return
	
	var nb_shots = 0
	for i in range(len(balls)):
		var ball = balls[i]
		if _laser_collide(ball):
			if reload_time <= 0.0 && Input.is_action_just_pressed("shoot"):
				_shoot_ball(ball)
				nb_shots += 1
			ball.activate(true)
		else:
			ball.activate(false)
			
		if ball.position.x < -16:
			_end_game(ball)
			return
	
	if reload_slow <= 0:
		if Input.is_action_pressed("slow") and $Control/SlowBar.slow_charge > 0:
			Global.speed = lerp(Global.speed, 0.2, 8*delta)
			$Control/SlowBar.slow_charge -= delta * 50 / Global.speed
			$Control/SlowBar.slow_charge = max(0, $Control/SlowBar.slow_charge)
			gray_scale = lerp(gray_scale, 1.0, delta * 8)
		else:
			Global.speed = lerp(Global.speed, 1.0, 8*delta)
			$Control/SlowBar.slow_charge += delta * 10 / Global.speed
			$Control/SlowBar.slow_charge = min(100.0, $Control/SlowBar.slow_charge)
			gray_scale = lerp(gray_scale, 0.0, delta * 8)
		if $Control/SlowBar.slow_charge <= 0:
			reload_slow = 1.0
	else:
		Global.speed = lerp(Global.speed, 1.0, 8*delta)
		gray_scale = lerp(gray_scale, 0.0, delta * 8)
		reload_slow -= delta 
	
	
	
	if nb_shots > 0:
		$Laser.shoot()
		reload_time = cst_reload_time
		if mode == "erase":
			$Control/Score.add_score(balls_to_erase.size())
			for ball_to_erase in balls_to_erase:
				balls.erase(ball_to_erase)
			balls_to_erase.clear()
			mode = "duplicate"
			$Laser.set_mode(mode)
			energy_bar.eraser_charge = 0
			energy_bar.eraser_level += 1
		elif mode == "duplicate":
			_add_charge(nb_shots)
	
	balls.append_array(balls_to_add)
	balls_to_add.clear()
	
	reload_time -= delta / Global.speed
	reload_time = max(reload_time, 0)
	$Control/Score.add_score(delta * (energy_bar.eraser_level + 1))

	
func start_game():
	_reset_all()
	var angle = rand_range(20, 60)
	_create_ball(get_viewport_rect().size / 2, 150, angle)
	_create_ball(get_viewport_rect().size / 2, 150, -angle)
	start_game = true
	
func _create_ball(position: Vector2, speed: float, angle: float):
	var ball = ball_sc.instance()
	ball.position = position
	ball.speed = speed
	ball.angle = angle
	add_child(ball)
	balls_to_add.append(ball)
	
func _laser_collide(ball: Node2D):
	if mode == "duplicate":
		return ($Laser.position.y > ball.position.y - ball_radius and 
			$Laser.position.y < ball.position.y + ball_radius)
	elif mode == "erase":
		return ($Laser.position.y > ball.position.y - ball_radius - 50 and 
			$Laser.position.y < ball.position.y + ball_radius + 50)
	else:
		return false
		
func _shoot_ball(ball: Node2D):
	if mode == "duplicate":
		_duplicate_ball(ball)
	elif mode == "erase":
		_erase_ball(ball)
		
func _duplicate_ball(ball: Node2D):
	var new_angle = rand_range(20, 40)
	var new_speed = ball.speed
	ball.speed = new_speed
	ball.angle = new_angle
	_create_ball(ball.position, new_speed, -new_angle)
	shake_time = 0.2

func _erase_ball(ball: Node2D):
	ball.delete()
	balls_to_erase.append(ball)
	shake_time = 0.2


func _add_charge(c: int):
	energy_bar.eraser_charge += c
	if energy_bar.eraser_charge >= energy_bar.max_eraser_charge():
		mode = "erase"
		$Laser.set_mode(mode)
		

func _end_game(ball: Node2D):
	var death_ins = death_sc.instance()
	death_ins.position.y = ball.position.y
	add_child(death_ins)
	
	balls_to_erase.append_array(balls)
	balls_to_erase.append_array(balls_to_add)
	for ball in balls_to_erase:
		ball.delete()
	balls.clear()
	balls_to_erase.clear()
	balls_to_add.clear()
	var new_high_score = false
	if $Control/Score._score > $Control/HiScore._hi_score:
		set_hi_score($Control/Score._score)
		save_hi_score($Control/Score._score)
		new_high_score = true
	emit_signal("end_game", $Control/Score._score, new_high_score)
	start_game = false

func set_hi_score(score: int):
	$Control/HiScore._hi_score = score
	
func save_hi_score(score: int):
	SaveUtility.save_file({"hi_score": score})
	
