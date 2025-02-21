extends Panel

var item_manager
var item_type = null
var interactable : bool = false

var button_showing : bool = false

func _ready():
	connect_to_item_manager()
	set_process_unhandled_input(true)
	$Button.disabled = false
	%NameLabel.visible = false
	$Button.pressed.connect(on_button_pressed)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)


func _input(event):
	if interactable == false:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			var mouse_pos = get_global_mouse_position()
			
			if get_global_rect().has_point(mouse_pos):
				if button_showing == false:
					button_showing = true
					$AnimationPlayer.play("button_pop_up")
			else:
				if button_showing == true:
					button_showing = false
					$AnimationPlayer.play("button_remove")
	
	set_button_status()


func set_button_status():
	if item_manager.ITEM_TYPE[self.item_type] == item_manager.ITEM_TYPE.RAW_FOOD:
		var fireplace = get_tree().get_first_node_in_group("fireplace")
		if fireplace.burning == false:
			$Button.disabled = true
		else:
			$Button.disabled = false
	
	var stats_manager = get_tree().get_first_node_in_group("stats_manager")
	if item_manager.ITEM_TYPE[self.item_type] == item_manager.ITEM_TYPE.COOKED_FOOD:
		if stats_manager.current_stats[stats_manager.STAT_TYPE.HUNGER] == stats_manager.maximum_stats[stats_manager.STAT_TYPE.HUNGER]:
			$Button.disabled = true
		else:
			$Button.disabled = false
	
	if item_manager.ITEM_TYPE[self.item_type] == item_manager.ITEM_TYPE.WATER:
		if stats_manager.current_stats[stats_manager.STAT_TYPE.THIRST] == stats_manager.maximum_stats[stats_manager.STAT_TYPE.THIRST]:
			$Button.disabled = true
		else:
			$Button.disabled = false
	
	if item_manager.ITEM_TYPE[self.item_type] == item_manager.ITEM_TYPE.MEDKIT:
		if stats_manager.current_stats[stats_manager.STAT_TYPE.HEALTH] == stats_manager.maximum_stats[stats_manager.STAT_TYPE.HEALTH]:
			$Button.disabled = true
		else:
			$Button.disabled = false
	
	if item_manager.ITEM_TYPE[self.item_type] == item_manager.ITEM_TYPE.FLAREGUN:
		var day_night_manager = get_tree().get_first_node_in_group("day_night_manager")
		if day_night_manager.day == true:
			$Button.disabled = true
		else:
			$Button.disabled = false


func set_type(item_type):
	self.item_type = item_type
	if item_manager.ITEM_TYPE[item_type] in item_manager.interactable_items:
		interactable = true
		set_button_message()
	
	set_item_name(item_type)
	set_image(item_type)


func set_button_message():
	var message = item_manager.items_to_interaction_message[item_manager.ITEM_TYPE[(self.item_type)]]
	$Button.text = " " + message + " "


func set_image(item_type):
	var item_key = item_manager.ITEM_TYPE[item_type]
	var item_image = item_manager.item_to_icon[item_key]
	%ItemDisplay.texture = item_image


func set_item_name(item_type):
	var item_key = item_manager.ITEM_TYPE[item_type]
	var item_name = item_manager.item_to_name[item_key]
	%NameLabel.text = item_name


func set_quantity(item_quantity : int):
	%QuantityLabel.text = str(item_quantity)


func remove_type():
	self.item_type = null
	interactable = false
	remove_image()
	remove_name()


func remove_name():
	%NameLabel.text = ""


func remove_image():
	%ItemDisplay.texture = null


func remove_quantity():
	%QuantityLabel.text = ""


func on_button_pressed():
	# Depending on item_type -> Take Action
	# print(item_type)
	var stats_manager = get_tree().get_first_node_in_group("stats_manager")
	
	if item_manager.ITEM_TYPE[item_type] == item_manager.ITEM_TYPE.COOKED_FOOD:
		stats_manager.increase_stat(stats_manager.STAT_TYPE.HUNGER, 2)
	if item_manager.ITEM_TYPE[item_type] == item_manager.ITEM_TYPE.WATER:
		stats_manager.increase_stat(stats_manager.STAT_TYPE.THIRST, 2)
	if item_manager.ITEM_TYPE[item_type] == item_manager.ITEM_TYPE.MEDKIT:
		stats_manager.increase_stat(stats_manager.STAT_TYPE.HEALTH, 4)
	if item_manager.ITEM_TYPE[item_type] == item_manager.ITEM_TYPE.BATTERY:
		var player = get_tree().get_first_node_in_group("player")
		var flashlight = player.find_child("Flashlight")
		flashlight.reload_battery()
	if item_manager.ITEM_TYPE[item_type] == item_manager.ITEM_TYPE.RAW_FOOD:
		var fireplace = get_tree().get_first_node_in_group("fireplace")
		if fireplace.burning == true:
			fireplace.add_to_cooking()
	if item_manager.ITEM_TYPE[item_type] == item_manager.ITEM_TYPE.FLAREGUN:
		var campsite = get_tree().get_first_node_in_group("campsite")
		campsite.fire_flaregun()
	
	
	# Logical changes to items
	item_manager.remove_items(item_manager.ITEM_TYPE[item_type], 1)
	
	# Visual changes
	var quantity = int(%QuantityLabel.text)
	quantity -= 1
	%QuantityLabel.text = str(quantity)
	
	# Remove item from inventory if necessary
	if quantity == 0:
		remove_type()
		remove_quantity()
		button_showing = false
		$Button.disabled = true
		$AnimationPlayer.play("button_remove")


func on_mouse_entered():
	%NameLabel.visible = true


func on_mouse_exited():
	%NameLabel.visible = false


func connect_to_item_manager():
	item_manager = get_tree().get_first_node_in_group("item_manager")

