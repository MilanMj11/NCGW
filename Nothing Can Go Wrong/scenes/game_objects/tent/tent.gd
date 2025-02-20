extends Node2D

@onready var interaction_active : bool = false
@onready var can_sleep : bool = false


func _ready():
	$InteractArea.body_entered.connect(on_body_entered)
	$InteractArea.body_exited.connect(on_body_exited)
	GameEvents.can_sleep.connect(on_can_sleep)


func _input(event):
	if interaction_active == true and can_sleep == true and event.is_action_pressed("select"):
		var day_night_manager = get_tree().get_first_node_in_group("day_night_manager")
		can_sleep = false
		$AnimationPlayer.play("out")
		day_night_manager.start_new_day()


func on_can_sleep():
	can_sleep = true


func on_body_entered(body: Node2D):
	if can_sleep:
		$AnimationPlayer.play("in")
		interaction_active = true


func on_body_exited(body: Node2D):
	if can_sleep:
		$AnimationPlayer.play("out")
		interaction_active = false
