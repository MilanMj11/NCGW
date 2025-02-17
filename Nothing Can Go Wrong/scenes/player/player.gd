extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
var fireplace


func _ready():
	connect_to_fireplace()


func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func connect_to_fireplace():
	fireplace = get_tree().get_first_node_in_group("fireplace")
