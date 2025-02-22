extends Node2D


@export var life_points : float = 2.0

@onready var ghost_image1 = preload("res://assets/ghosts/ghost1.png")
@onready var ghost_image2 = preload("res://assets/ghosts/ghost2.png")
@onready var ghost_image3 = preload("res://assets/ghosts/ghost3.png")

@onready var possible_images : Array = [ghost_image1, ghost_image2, ghost_image3]

var player
var flashlight
var max_health


func _ready():
	connect_to_player()
	connect_to_flashlight()
	$Sprite2D.texture = possible_images.pick_random()
	$LifeTime.timeout.connect(on_lifetime_timer_timeout)
	max_health = life_points
	if randf() < 0.25:
		AudioManager.play_sound_at_position(self.global_position, SoundEffect.SOUND_EFFECT_TYPE.WHISPER)
	

func _process(delta):
	var alpha_value : float = life_points / max_health
	self.modulate = Color(1, 1, 1, alpha_value)
	
	player.sanity_induction += 1 * delta
	
	if !flashlight.is_on:
		return
	
	var mouse_position = get_global_mouse_position()
	var flashlight_position = flashlight.global_position
	
	var vec_AB = (self.global_position - flashlight_position).normalized()
	var vec_BC = (mouse_position - flashlight_position).normalized()
	
	var angle = abs(rad_to_deg(vec_AB.angle_to(vec_BC)))
	
	if angle <= 12:
		# the flashlight hits the enemy
		life_points -= 1 * delta
		player.sanity_induction -= 1 * delta
	
	
	if life_points <= 0.0:
		var enemy_manager = get_tree().get_first_node_in_group("enemy_manager")
		if enemy_manager.enemies_spawning == false:
			if get_parent().get_child_count() == 2:
				GameEvents.emit_can_sleep()
		self.queue_free()



func connect_to_player():
	player = get_tree().get_first_node_in_group("player")


func connect_to_flashlight():
	flashlight = player.find_child("Flashlight")


func on_lifetime_timer_timeout():
	# if it's just him left and the player
	if get_parent().get_child_count() == 2:
		GameEvents.emit_can_sleep()
	queue_free()
