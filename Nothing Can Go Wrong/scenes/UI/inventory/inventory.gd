extends Control

@onready var inventory_total_slots : int = 12

func set_invetory_slot(slot_number: int, item_type, item_quantity: int):
	var inventory_slot_name = "InventorySlot" + str(slot_number)
	var inventory_slot = find_child(inventory_slot_name)
	inventory_slot.set_type(item_type)
	inventory_slot.set_quantity(item_quantity)


func empty_inventory_slot(slot_number : int):
	var inventory_slot_name = "InventorySlot" + str(slot_number)
	var inventory_slot = find_child(inventory_slot_name)
	inventory_slot.remove_type()
	inventory_slot.remove_quantity()

