extends Area2D

# upgrades, ablities , so on ...
enum menu_type { none, test_menu, inventory_menu }

@export var menu_to_show : menu_type
@export_multiline var label_message : String = "Press 'E'"

var menu_manager : Node
var button_active : bool = false
var menu_on_screen : bool = false


func _ready():
	connect_to_menu_manager()
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	$PanelContainer/Label.text = label_message

func _process(delta):
	var E_pressed = Input.is_action_pressed("select")
	var ESC_pressed = Input.is_action_pressed("exit")
	
	if button_active and (menu_on_screen == false) and E_pressed:
		show_selected_menu()
		button_active = false
		await menu_manager.transition_finished
		menu_on_screen = true
	
	if menu_on_screen and ESC_pressed:
		remove_selected_menu()
		button_active = true
		menu_on_screen = false
		Input.action_release("exit")


func show_selected_menu():
	if menu_to_show == menu_type.test_menu:
		menu_manager.show_test_menu()
	if menu_to_show == menu_type.inventory_menu:
		menu_manager.show_inventory_menu()


func remove_selected_menu():
	menu_manager.remove_menu()


func connect_to_menu_manager():
	menu_manager = get_tree().get_first_node_in_group("menu_manager")


func on_body_entered(body: Node2D):
	button_active = true
	$AnimationPlayer.play("in")
	

func on_body_exited(body: Node2D):
	button_active = false
	$AnimationPlayer.play("out")
	
