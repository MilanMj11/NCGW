extends CanvasLayer


func _ready():
	%ReturnButton.pressed.connect(on_return_button_pressed)
	var day_night_manager = get_tree().get_first_node_in_group("day_night_manager")
	var number_of_days_survived = day_night_manager.current_day
	var message = %OverviewLabel.text
	var message_with_days = message.replace("?", str(number_of_days_survived).pad_zeros(2))
	%OverviewLabel.text = message_with_days
	

func on_return_button_pressed():
	AudioManager.play_sound_at_position(Vector2(300, 160), SoundEffect.SOUND_EFFECT_TYPE.BUTTON_PRESSED)
	var main_node = get_tree().get_first_node_in_group("main")
	main_node.return_to_main_menu()
