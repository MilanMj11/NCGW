extends Node2D


@onready var lifetime : float = 30.0
var flicker_threshold : float = 1.0
var flicker_time : float = 0.0


func _process(delta):
	face_at_mouse_position()
	if $PointLight2D.enabled:
		lifetime -= delta
	
	if lifetime < flicker_threshold:
		flicker_time += delta
		if flicker_time > randf_range(0.05, 0.2):
			$PointLight2D.enabled = !$PointLight2D.enabled
			flicker_time = 0.0
	
	if lifetime <= 0:
		turn_on_off(false)
		lifetime = 0


func _input(event):
	if event.is_action_pressed("turn_on_flashlight"):
		turn_on_off(!($PointLight2D.enabled))


func reload_battery():
	lifetime += 30.0
	if lifetime > 60:
		lifetime = 60


func face_at_mouse_position():
	var mouse_pos = get_global_mouse_position()
	self.look_at(mouse_pos)
	

func turn_on_off(value: bool):
	$PointLight2D.enabled = value
