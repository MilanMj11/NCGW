extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var sanity_induction : float = 0.0
@onready var player_died_image = preload("res://assets/player_died.png")
@onready var player_behind = preload("res://assets/player_behind.png")
@onready var player_front = preload("res://assets/temporary_character.png")

var fireplace
var facing_direction_sign = 1


func _ready():
	connect_to_fireplace()


func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if sanity_induction > 80.0:
		var stats_manager = get_tree().get_first_node_in_group("stats_manager")
		stats_manager.decrease_stat(stats_manager.STAT_TYPE.SANITY, 1)
		sanity_induction -= 80
	
	var movement_actions = ["move_up", "move_down", "move_left", "move_right"]
	var any_movement : bool = false
	for movement_action in movement_actions:
		if Input.is_action_pressed(movement_action):
			any_movement = true
			if $AnimationPlayer.current_animation != "run":
				$AnimationPlayer.play("run")
	
	if any_movement == false and $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
		$AnimationPlayer.seek(0, true)
		
	
	face_correct_direction()


func reduce_all_movement():
	var day_night_manager = get_tree().get_first_node_in_group("day_night_manager")
	var movement_tween = create_tween()
	movement_tween.tween_property(velocity_component, "current_speed", 0, 5)
	movement_tween.tween_callback(day_night_manager.play_died)


func set_velocity_max_speed(value: int):
	find_child("VelocityComponent").set_max_speed(value)
	find_child("VelocityComponent").update_current_stats()


func face_correct_direction():
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x < global_position.x:
		facing_direction_sign = -1
	else:
		facing_direction_sign = 1
	
	if mouse_pos.y >= global_position.y:
		$Visuals/Sprite2D.texture = player_front
		%Flashlight.find_child("Sprite2D").visible = true
	else:
		$Visuals/Sprite2D.texture = player_behind
		%Flashlight.find_child("Sprite2D").visible = false
	
	$Visuals.scale = Vector2(-facing_direction_sign, 1)


func died():
	$Visuals/Sprite2D.texture = player_died_image
	$AnimationPlayer.stop()
	$AnimationPlayer.seek(0, true)
	set_process(false)


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func connect_to_fireplace():
	fireplace = get_tree().get_first_node_in_group("fireplace")
