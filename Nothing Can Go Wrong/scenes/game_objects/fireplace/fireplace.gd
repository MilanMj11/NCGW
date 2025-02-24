extends Node2D

signal fireplace_lighted
signal fireplace_extinguished

@onready var cooking_stand_empty = preload("res://assets/props/cooking_stand_empty.png")
@onready var cooking_stand = preload("res://assets/props/cooking_stand.png")

@onready var fire_light = $PointLight2D
@onready var interaction_active : bool = false
var flickering : bool = false
var burning : bool = false


func _ready():
	$InteractArea.body_entered.connect(on_body_entered)
	$InteractArea.body_exited.connect(on_body_exited)
	$BurnTimer.timeout.connect(on_burn_timer_timeout)
	$CookingTimer.timeout.connect(on_cooking_timer_timeout)
	$OnePieceCookTimer.timeout.connect(on_one_piece_cook_timer)
	$SoundTimer.timeout.connect(on_sound_timer_timeout)
	burning = false
	%Fire.visible = false
	fire_light.energy = 0.0

var audio2d


func start_fire():
	$AnimationPlayer.play("start")
	%Fire.visible = true
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("burn")
	burning = true
	flickering = true
	start_light_flicker()
	$BurnTimer.start()
	fireplace_lighted.emit()
	audio2d = AudioManager.play_sound_at_position(self.global_position, SoundEffect.SOUND_EFFECT_TYPE.FIRE)
	$SoundTimer.start(16)


func stop_fire():
	flickering = false
	$AnimationPlayer.play("stops")
	await $AnimationPlayer.animation_finished
	%Fire.visible = false
	burning = false
	fireplace_extinguished.emit()
	if audio2d != null:
		audio2d.stop()


func on_sound_timer_timeout():
	if burning == true:
		audio2d = AudioManager.play_sound_at_position(self.global_position, SoundEffect.SOUND_EFFECT_TYPE.FIRE)
		$SoundTimer.start(16)


func _input(event):
	if Input.is_action_just_pressed("select") and interaction_active == true:
		var item_manager = get_tree().get_first_node_in_group("item_manager")
		if item_manager.current_items[item_manager.ITEM_TYPE.WOOD] >= 2:
			item_manager.remove_items(item_manager.ITEM_TYPE.WOOD, 2)
			start_fire()


func add_to_cooking():
	if $CookingTimer.time_left > 0:
		$CookingTimer.wait_time += 5
		$CookingTimer.start()
	else:
		$CookingTimer.start(5)
		$OnePieceCookTimer.start()
	
	$CookingStand.texture = cooking_stand


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


func on_burn_timer_timeout():
	stop_fire()


func on_body_entered(body: Node2D):
	if burning:
		return
	$AnimationPlayer2.play("in")
	interaction_active = true


func on_body_exited(body: Node2D):
	if burning:
		return
	$AnimationPlayer2.play("out")
	interaction_active = false


func on_cooking_timer_timeout():
	$CookingStand.texture = cooking_stand_empty


func on_one_piece_cook_timer():
	var item_manager = get_tree().get_first_node_in_group("item_manager")
	item_manager.add_items(item_manager.ITEM_TYPE.COOKED_FOOD, 1)
	
	if $CookingTimer.time_left > 0:
		$OnePieceCookTimer.start()
