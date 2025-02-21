extends Node2D


func _ready():
	# %Fireplace.find_child("AnimationPlayer").play("burn")
	set_morning()


func player_walk_in_forest(backwards: bool = false):
	var gamecamera = get_tree().get_first_node_in_group("game_camera")
	gamecamera.lock()
	if backwards:
		$AnimationPlayer.play_backwards("player_walk_in_forest")
	else:
		$AnimationPlayer.play("player_walk_in_forest")
	await $AnimationPlayer.animation_finished
	gamecamera.unlock()


func player_rest(backwards: bool = false):
	var gamecamera = get_tree().get_first_node_in_group("game_camera")
	gamecamera.lock()
	if backwards:
		$AnimationPlayer.play_backwards("player_rest")
	else:
		$AnimationPlayer.play("player_rest")
	await $AnimationPlayer.animation_finished
	gamecamera.unlock()


func fire_flaregun():
	$AnimationPlayer.play("fire_flaregun")
	await $AnimationPlayer.animation_finished
	GameEvents.emit_flaregun_fired()


func set_morning():
	%Sun.color = Color(1, 1, 0.615)


func set_sunset():
	#%Sun.color = Color(0.53, 0.3, 0.2)
	%Sun.color = Color(0.75, 0.47, 0.33)


func set_night():
	%Sun.color = Color(0.13, 0.03, 0.02)
