extends Node2D

@onready var fire_light = $PointLight2D
var flickering : bool = false
var burning : bool = false

func _ready():
	burning = false
	%Fire.visible = false
	fire_light.energy = 0.0


func start_fire():
	$AnimationPlayer.play("start")
	%Fire.visible = true
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("burn")
	burning = true
	flickering = true
	start_light_flicker()


func stop_fire():
	flickering = false
	$AnimationPlayer.play("stops")
	await $AnimationPlayer.animation_finished
	%Fire.visible = false
	burning = false


func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		if !burning:
			start_fire()
		else:
			stop_fire()


func start_light_flicker():
	if !flickering:
		return
	
	var new_energy = randf_range(1.15, 1.4)
	var new_scale = randf_range(1, 1.1)
	
	# MIGHT CHANGE LATER IF VISUAL EFFECT GETS ANNOYING
	if randf() < 0.4:
		var scale_tween = create_tween()
		scale_tween.tween_property(fire_light, "texture_scale", new_scale, randf_range(0.15, 0.3))
	
	
	var light_tween = create_tween()
	light_tween.tween_property(fire_light, "energy", new_energy, randf_range(0.3, 0.5))
	light_tween.tween_callback(start_light_flicker)
