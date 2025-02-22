extends Node
class_name VelocityComponent

@export var max_speed : int = 60
@export var max_acceleration : float = 5

@onready var current_speed = max_speed
@onready var current_acceleration = max_acceleration

var velocity = Vector2.ZERO


func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * current_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-current_acceleration * get_process_delta_time()))


func accelerate_towards_player():
	# Owner meaning the Node that owns the velocity component
	# -> In this case meaning the enemy;
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return
	
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var direction = (player.global_position - owner_node2d.global_position).normalized()
	accelerate_in_direction(direction)


func update_current_stats():
	current_speed = max_speed
	current_acceleration = max_acceleration


func set_max_speed(value: int):
	max_speed = value



func decelerate():
	accelerate_in_direction(Vector2.ZERO)


func move(character_body: CharacterBody2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity
