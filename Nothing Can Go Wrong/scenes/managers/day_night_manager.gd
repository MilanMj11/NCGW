extends Node

signal half_transitioned
signal player_returned


# day = true ( Day ) , day = false ( Night ) 
@onready var day : bool = true
@onready var current_day : int = 0

var chopped_wood : bool = false
var hunted : bool = false
var explored : bool = false
var rested : bool = false


var night_settles_messages : Array = [
	"The night tightens\n its grip...",
	"Night begins\n to settle...",
	"A creeping chill\n announces the night's\n arrival...",
	"Shadows writhe\n as the night\n takes over...",
	"Whispers ride\n the wind as the\n night claims the land..."
]


func _ready():
	GameEvents.decision_menu_closed.connect(play_decision_animation)
	GameEvents.decisions_taken.connect(set_decisions_taken)
	start_new_day()


func set_decisions_taken(bitwise_representation):
	rested = bool(bitwise_representation % 2)
	bitwise_representation /= 2
	explored = bool(bitwise_representation % 2)
	bitwise_representation /= 2
	hunted = bool(bitwise_representation % 2)
	bitwise_representation /= 2
	chopped_wood = bool(bitwise_representation % 2)
	bitwise_representation /= 2



func emit_half_animation():
	half_transitioned.emit()


func play_decision_animation(energy_consumed):
	
	var player = get_tree().get_first_node_in_group("player")
	player.set_process(false)
	player.find_child("Flashlight").find_child("PointLight2D").enabled = false
	
	var gamecamera = get_tree().get_first_node_in_group("game_camera")
	gamecamera.center_camera()
	await gamecamera.camera_centered
	
	if energy_consumed > 0: 
		walk_in_and_out_of_forest()
	else:
		rest()
	
	await get_tree().create_timer(3).timeout
	
	# In between
	var campsite = get_tree().get_first_node_in_group("campsite")
	campsite.set_sunset()
	
	night_settles(energy_consumed)
	await player_returned
	player.set_process(true)
	
	day = false
	GameEvents.emit_night_settled()
	
	# Here I subtract and add the player's resources and stats
	# based on actions taken and randomness elements 
	
	await get_tree().create_timer(2.5).timeout
	
	var actions_manager = get_tree().get_first_node_in_group("actions_manager")
	actions_manager.set_actions(chopped_wood, hunted, explored, rested)
	
	var menu_manager = get_tree().get_first_node_in_group("menu_manager")
	menu_manager.show_rewards_menu()
	#print(hunted)
	
	
	var sun_tween = create_tween()
	var sun = campsite.find_child("Sun")
	sun_tween.tween_property(sun, "color", Color(0.13, 0.03, 0.02), 15)
	await sun_tween.finished
	
	# print("NOW IT'S NIGHT")
	GameEvents.emit_middle_of_night()


func night_settles(energy_consumed):
	%NightMessage.text = night_settles_messages.pick_random()
	$AnimationPlayer.play("night_message")
	await $AnimationPlayer.animation_finished
	
	var gamecamera = get_tree().get_first_node_in_group("game_camera")
	gamecamera.center_camera()
	await gamecamera.camera_centered
	
	if energy_consumed > 0: 
		walk_in_and_out_of_forest(true)
	else:
		rest(true)
	
	player_returned.emit()



func rest(backwards: bool = false):
	if backwards:
		$AnimationPlayer.play_backwards("rest")
	else:
		$AnimationPlayer.play("rest")
	
	if !backwards:
		await half_transitioned
	
	var campsite = get_tree().get_first_node_in_group("campsite")
	campsite.player_rest(backwards)



func walk_in_and_out_of_forest(backwards: bool = false):
	if backwards:
		$AnimationPlayer.play_backwards("walk_into_forest")
	else:
		$AnimationPlayer.play("walk_into_forest")
	
	if !backwards:
		await half_transitioned
	
	var campsite = get_tree().get_first_node_in_group("campsite")
	campsite.player_walk_in_forest(backwards)


func helpers_arrived():
	%DayLabel.text = "HELPERS\n ARRIVED"
	
	get_tree().paused = true
	ScreenTransition.transition_first_half()
	await ScreenTransition.transitioned_first_half
	
	# This is one "in-between"
	var campsite = get_tree().get_first_node_in_group("campsite")
	campsite.find_child("Helpers").visible = true
	
	$AnimationPlayer.play("show_day")
	await $AnimationPlayer.animation_finished
	
	# This is another "in-between"
	campsite.set_morning()
	
	ScreenTransition.transition_second_half()
	await ScreenTransition.transitioned_second_half
	get_tree().paused = false
	
	await get_tree().create_timer(3).timeout
	
	var menu_manager = get_tree().get_first_node_in_group("menu_manager")
	menu_manager.show_end_of_game_menu()



func rest_crazy():
	%DayLabel.text = "GONE CRAZY"
	
	get_tree().paused = true
	ScreenTransition.transition_first_half()
	await ScreenTransition.transitioned_first_half
	
	# This is one "in-between"
	
	$AnimationPlayer.play("show_day")
	await $AnimationPlayer.animation_finished
	
	# This is another "in-between"
	var game_camera = get_tree().get_first_node_in_group("game_camera")
	game_camera.lock()
	
	var campsite = get_tree().get_first_node_in_group("campsite")
	campsite.set_morning()
	
	var player = get_tree().get_first_node_in_group("player")
	player.visible = false
	
	ScreenTransition.transition_second_half()
	await ScreenTransition.transitioned_second_half
	get_tree().paused = false
	
	await get_tree().create_timer(3).timeout
	game_camera.unlock()
	
	var menu_manager = get_tree().get_first_node_in_group("menu_manager")
	menu_manager.show_lost_menu()


func play_first_day():
	%DayLabel.text = "DAY " + str(current_day)
	
	get_tree().paused = true
	ScreenTransition.no_animation()
	await ScreenTransition.transitioned_first_half
	
	$AnimationPlayer.play("show_day")
	await $AnimationPlayer.animation_finished
	
	# This is another "in-between"
	var campsite = get_tree().get_first_node_in_group("campsite")
	campsite.set_morning()
	
	ScreenTransition.transition_second_half()
	await ScreenTransition.transitioned_second_half
	get_tree().paused = false
	
	GameEvents.emit_day_changed(current_day)
	
	day = true


func start_new_day():
	var stats_manager = get_tree().get_first_node_in_group("stats_manager")
	if stats_manager.current_stats[stats_manager.STAT_TYPE.SANITY] == 0:
		rest_crazy()
		return
	
	
	var main_node = get_tree().get_first_node_in_group("main")
	if main_node.helpers_come == true:
		helpers_arrived()
		return
	
	
	stats_manager.increase_stat(stats_manager.STAT_TYPE.HEALTH, 1)
	var sanity_amount = stats_manager.current_stats[stats_manager.STAT_TYPE.SANITY]
	stats_manager.increase_stat(stats_manager.STAT_TYPE.ENERGY, sanity_amount)
	
	var fireplace = get_tree().get_first_node_in_group("fireplace")
	fireplace.stop_fire()
	
	current_day += 1
	
	if current_day == 1:
		play_first_day()
		return
	
	%DayLabel.text = "DAY " + str(current_day)
	
	get_tree().paused = true
	ScreenTransition.transition_first_half()
	await ScreenTransition.transitioned_first_half
	
	# This is one "in-between"
	
	$AnimationPlayer.play("show_day")
	await $AnimationPlayer.animation_finished
	
	# This is another "in-between"
	var campsite = get_tree().get_first_node_in_group("campsite")
	campsite.set_morning()
	
	ScreenTransition.transition_second_half()
	await ScreenTransition.transitioned_second_half
	get_tree().paused = false
	
	GameEvents.emit_day_changed(current_day)
	
	day = true
