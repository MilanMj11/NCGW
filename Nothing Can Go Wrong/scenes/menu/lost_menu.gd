extends CanvasLayer


func _ready():
	%ReturnButton.pressed.connect(on_return_button_pressed)


func on_return_button_pressed():
	AudioManager.play_sound_at_position(Vector2(300, 160), SoundEffect.SOUND_EFFECT_TYPE.BUTTON_PRESSED)
	var main_node = get_tree().get_first_node_in_group("main")
	main_node.return_to_main_menu()
