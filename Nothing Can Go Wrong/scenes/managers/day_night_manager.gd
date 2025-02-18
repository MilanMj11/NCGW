extends Node

# day = true ( Day ) , day = false ( Night ) 
@onready var day : bool = true
@onready var current_day : int = 0


func _ready():
	#start_new_day()
	pass


func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_T:
		start_new_day()


func start_new_day():
	current_day += 1
	%DayLabel.text = "DAY " + str(current_day)
	
	get_tree().paused = true
	ScreenTransition.transition_first_half()
	await ScreenTransition.transitioned_first_half
	
	# This is one "in-between"
	
	$AnimationPlayer.play("show_day")
	await $AnimationPlayer.animation_finished
	
	# This is another "in-between"
	
	ScreenTransition.transition_second_half()
	await ScreenTransition.transitioned_second_half
	get_tree().paused = false
	
	GameEvents.emit_day_changed(current_day)
	
	day = true
