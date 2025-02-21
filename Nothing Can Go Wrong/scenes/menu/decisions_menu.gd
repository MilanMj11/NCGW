extends CanvasLayer

enum BUTTON_TYPE {CHOP_WOOD, HUNT, EXPLORE, REST}

var stats_manager
var current_energy_amount : int
var initial_energy_amount : int

@onready var button_to_energy_cost : Dictionary = {
	BUTTON_TYPE.CHOP_WOOD : 5,
	BUTTON_TYPE.HUNT : 4,
	BUTTON_TYPE.EXPLORE : 3,
	BUTTON_TYPE.REST : 0
}


@onready var button_to_node : Dictionary = {
	BUTTON_TYPE.CHOP_WOOD : %ChopWoodButton,
	BUTTON_TYPE.HUNT : %HuntButton,
	BUTTON_TYPE.EXPLORE : %ExploreButton,
	BUTTON_TYPE.REST : %RestButton
}


@onready var button_selected : Dictionary = {
	BUTTON_TYPE.CHOP_WOOD : false,
	BUTTON_TYPE.HUNT : false,
	BUTTON_TYPE.EXPLORE : false,
	BUTTON_TYPE.REST : false
}


func _ready():
	connect_to_stats_manager()
	current_energy_amount = stats_manager.current_stats[stats_manager.STAT_TYPE.ENERGY]
	initial_energy_amount = current_energy_amount
	set_label_prices()
	%ChopWoodButton.toggled.connect(on_chopwood_button_down)
	%HuntButton.toggled.connect(on_hunt_button_down)
	%ExploreButton.toggled.connect(on_explore_button_down)
	%RestButton.toggled.connect(on_rest_button_down)
	%ConfirmButton.pressed.connect(on_confirm_button_pressed)
	%EscButton.pressed.connect(on_esc_button_pressed)


func _process(delta):
	%CostLabel.text = str(initial_energy_amount - current_energy_amount)
	
	var is_any_button_pressed: bool = false
	
	for type in BUTTON_TYPE:
		var key = BUTTON_TYPE[type]
		if button_to_node[key].button_pressed:
			is_any_button_pressed = true
		
		if BUTTON_TYPE[type] == BUTTON_TYPE.REST:
			continue
			
		button_to_node[key].disabled = false
		if button_to_energy_cost[key] > current_energy_amount and button_to_node[key].button_pressed == false:
			button_to_node[key].disabled = true
	
	if !is_any_button_pressed:
		%ConfirmButton.disabled = true
	else:
		%ConfirmButton.disabled = false
	


func _input(event):
	if event.is_action_pressed("exit"):
		var menu_manager = get_tree().get_first_node_in_group("menu_manager")
		menu_manager.remove_menu()


func set_label_prices():
	%ChopWoodCostLabel.text = "x" + str(button_to_energy_cost[BUTTON_TYPE.CHOP_WOOD])
	%HuntCostLabel.text = "x" + str(button_to_energy_cost[BUTTON_TYPE.HUNT])
	%ExploreCostLabel.text = "x" + str(button_to_energy_cost[BUTTON_TYPE.EXPLORE])
	%RestCostLabel.text = "x" + str(button_to_energy_cost[BUTTON_TYPE.REST])


func on_chopwood_button_down(toggled_on: bool):
	%RestButton.set_pressed_no_signal(false)
	button_selected[BUTTON_TYPE.CHOP_WOOD] = true
	var sign = 1
	if toggled_on:
		sign = -1
	current_energy_amount += sign * button_to_energy_cost[BUTTON_TYPE.CHOP_WOOD]
	

func on_hunt_button_down(toggled_on: bool):
	%RestButton.set_pressed_no_signal(false)
	button_selected[BUTTON_TYPE.HUNT] = true
	var sign = 1
	if toggled_on:
		sign = -1
	current_energy_amount += sign * button_to_energy_cost[BUTTON_TYPE.HUNT]


func on_explore_button_down(toggled_on: bool):
	%RestButton.set_pressed_no_signal(false)
	button_selected[BUTTON_TYPE.EXPLORE] = true
	var sign = 1
	if toggled_on:
		sign = -1
	current_energy_amount += sign * button_to_energy_cost[BUTTON_TYPE.EXPLORE]


func on_rest_button_down(toggled_on: bool):
	
	%ChopWoodButton.set_pressed_no_signal(false)
	%HuntButton.set_pressed_no_signal(false)
	%ExploreButton.set_pressed_no_signal(false)
	current_energy_amount = initial_energy_amount
	# %RestButton.button_pressed = true
	
	'''
	var sign = 1
	if toggled_on:
		sign = -1
	button_selected[BUTTON_TYPE.REST] = true
	current_energy_amount += sign * button_to_energy_cost[BUTTON_TYPE.REST]
	'''


func on_confirm_button_pressed():
	%EscButton.disabled = true
	var map = get_tree().get_first_node_in_group("map")
	map.available = false
	
	stats_manager.decrease_stat(stats_manager.STAT_TYPE.ENERGY, int(%CostLabel.text))
	$AnimationPlayer.play("out")
	await $AnimationPlayer.animation_finished
	GameEvents.emit_decision_menu_closed(int(%CostLabel.text))
	
	var bitwise_representation_of_decisions = int(%ChopWoodButton.button_pressed) * 8\
	+ int(%HuntButton.button_pressed) * 4\
	+ int(%ExploreButton.button_pressed) * 2\
	+ int(%RestButton.button_pressed) * 1
	GameEvents.emit_decisions_taken(bitwise_representation_of_decisions)
	var menu_manager = get_tree().get_first_node_in_group("menu_manager")
	menu_manager.remove_menu()


func connect_to_stats_manager():
	stats_manager = get_tree().get_first_node_in_group("stats_manager")


func on_esc_button_pressed():
	var menu_manager = get_tree().get_first_node_in_group("menu_manager")
	menu_manager.remove_menu()
