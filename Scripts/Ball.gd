extends Node2D

var cumul_delta: float

var speed: float setget set_speed, get_speed
var angle: float setget set_angle, get_angle
var _dest_speed: float
var _real_speed: float
var _real_angle: float

var start_delete = false
var scale_laser_blue = 1.5
var scale_laser_white = 1.0
var radius = 1
	
func _process(delta):
	delta = Global.speed * delta
	
	var offset = 0
	if position.x > get_viewport_rect().size.x - radius:
		_real_angle = PI - _real_angle
		offset = position.x - get_viewport_rect().size.x  - radius
		position.x = get_viewport_rect().size.x - radius
	if position.y > get_viewport_rect().size.y - radius:
		_real_angle = - _real_angle
		offset = position.y - get_viewport_rect().size.y - radius
		position.y = get_viewport_rect().size.y - radius
	if position.y < 42 + radius:
		_real_angle = - _real_angle
		offset = position.y + radius
		position.y = 42 + radius
		
	position.x = position.x + (_real_speed + offset) * cos(_real_angle) * delta
	position.y = position.y + (_real_speed + offset) * sin(_real_angle) * delta
	_real_speed = lerp(_real_speed, _dest_speed, 15 * delta)
	
	$LaserBlue.scale.x = scale_laser_blue + 0.2 * cos(cumul_delta * 50)
	$LaserBlue.scale.y = scale_laser_blue + 0.2 * cos(cumul_delta * 15)
	$LaserWhite.scale.x = scale_laser_white + 0.2 * cos(cumul_delta * 15)
	$LaserWhite.scale.y = scale_laser_white + 0.2 * cos(cumul_delta * 15)
	cumul_delta += delta
	
	if start_delete:
		scale_laser_blue = lerp(scale_laser_blue, 0.0, 5 * delta)
		scale_laser_white = lerp(scale_laser_white, 0.0, 5 * delta)
		if scale_laser_blue <= 0.1:
			queue_free()
	
func activate(b: bool):
	if b:
		modulate.a = 1
	else:
		modulate.a = 0.4

func set_angle(new_angle: float):
	_real_angle = deg2rad(new_angle)
	
func get_angle():
	return _real_angle
	
func set_speed(new_speed: float):
	_real_speed = new_speed * 6
	_dest_speed = new_speed
	
func get_speed():
	return _dest_speed
	
func delete():
	start_delete = true
	_dest_speed = 0
	
