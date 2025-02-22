extends CanvasLayer


func _ready():
	get_tree().paused = false
	AudioManager.play_ambient_sound(SoundEffect.SOUND_EFFECT_TYPE.FOREST_DAY)
	%PlayButton.pressed.connect(on_play_button_pressed)
	%ExitButton.pressed.connect(on_exit_button_pressed)
	%OptionsButton.pressed.connect(on_options_button_pressed)


func on_play_button_pressed():
	AudioManager.play_sound_at_position(Vector2(640, 360), SoundEffect.SOUND_EFFECT_TYPE.BUTTON_PRESSED)
	$AnimationPlayer.play("play")
	await $AnimationPlayer.animation_finished
	%ContinueButton.pressed.connect(on_continue_button_pressed)


func on_continue_button_pressed():
	AudioManager.play_sound_at_position(Vector2(640, 360), SoundEffect.SOUND_EFFECT_TYPE.BUTTON_PRESSED)
	get_tree().change_scene_to_file("res://main/main.tscn")


func on_options_button_pressed():
	AudioManager.play_sound_at_position(Vector2(640, 360), SoundEffect.SOUND_EFFECT_TYPE.BUTTON_PRESSED)


func on_exit_button_pressed():
	AudioManager.play_sound_at_position(Vector2(640, 360), SoundEffect.SOUND_EFFECT_TYPE.BUTTON_PRESSED)
	get_tree().quit()
