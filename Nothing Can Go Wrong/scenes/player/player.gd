extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var sanity_induction : float = 0.0

var fireplace
var facing_direction_sign = 1


func _ready():
	connect_to_fireplace()


func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if sanity_induction > 100.0:
		var stats_manager = get_tree().get_first_node_in_group("stats_manager")
		stats_manager.decrease_stat(stats_manager.STAT_TYPE.SANITY, 1)
		sanity_induction -= 100
	
	face_correct_direction()


func face_correct_direction():
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x < global_position.x:
		facing_direction_sign = -1
	else:
		facing_direction_sign = 1
	
	$Visuals.scale = Vector2(-facing_direction_sign, 1)



func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func connect_to_fireplace():
	fireplace = get_tree().get_first_node_in_group("fireplace")
