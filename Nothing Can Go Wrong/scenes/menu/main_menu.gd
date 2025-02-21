extends CanvasLayer


func _ready():
	%PlayButton.pressed.connect(on_play_button_pressed)



func on_play_button_pressed():
	$AnimationPlayer.play("play")
	await $AnimationPlayer.animation_finished
	%ContinueButton.pressed.connect(on_continue_button_pressed)


func on_continue_button_pressed():
	get_tree().change_scene_to_file("res://main/main.tscn")
