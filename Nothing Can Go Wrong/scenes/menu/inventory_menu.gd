extends CanvasLayer

var item_manager

func _ready():
	connect_to_item_manager()
	update_inventory()
	%EscButton.pressed.connect(on_esc_button_pressed)


func update_inventory():
	
	var slot_counter = 1
	
	for type in item_manager.ITEM_TYPE:
		var key = item_manager.ITEM_TYPE[type]
		if item_manager.current_items[key] > 0:
			var item_quantity = item_manager.current_items[key]
			#var item_icon = item_manager.item_to_icon[key]
			%Inventory.set_invetory_slot(slot_counter, type, item_quantity)
		else:
			%Inventory.empty_inventory_slot(slot_counter)
		
		slot_counter += 1
	
	# Empty the other slots
	for counter in range(slot_counter, %Inventory.inventory_total_slots + 1):
		%Inventory.empty_inventory_slot(counter)


func on_esc_button_pressed():
	Input.action_press("exit")


func connect_to_item_manager():
	item_manager = get_tree().get_first_node_in_group("item_manager")
