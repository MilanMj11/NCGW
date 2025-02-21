extends CanvasLayer


func _ready():
	%ReturnButton.pressed.connect(on_return_button_pressed)


func on_return_button_pressed():
	var main_node = get_tree().get_first_node_in_group("main")
	main_node.return_to_main_menu()
