extends Node

enum ITEM_TYPE {RAW_FOOD, COOKED_FOOD, WATER, WOOD, FLASHLIGHT, FLAREGUN, BATTERY}

@onready var current_items : Dictionary = {
	ITEM_TYPE.RAW_FOOD : 0,
	ITEM_TYPE.COOKED_FOOD : 0,
	ITEM_TYPE.WATER : 0,
	ITEM_TYPE.WOOD : 0,
	ITEM_TYPE.FLASHLIGHT : 1,
	ITEM_TYPE.FLAREGUN : 0,
	ITEM_TYPE.BATTERY : 0
}


@onready var item_to_icon : Dictionary = {
	ITEM_TYPE.RAW_FOOD : preload("res://assets/icons/food_icon.png"),
	ITEM_TYPE.COOKED_FOOD : preload("res://assets/icons/cooked_food_icon.png"),
	ITEM_TYPE.WATER : preload("res://assets/icons/bottle_of_water_icon.png"),
	ITEM_TYPE.WOOD : preload("res://assets/icons/wood_icon.png"),
	ITEM_TYPE.FLASHLIGHT : preload("res://assets/icons/flashlight_icon.png"),
	ITEM_TYPE.FLAREGUN : preload("res://assets/icons/flaregun_icon.png"),
	ITEM_TYPE.BATTERY : preload("res://assets/icons/battery_icon.png")
}


func add_items(type: ITEM_TYPE, quantity: int = 1):
	current_items[type] += quantity


func remove_items(type: ITEM_TYPE, quantity: int = 1):
	if current_items[type] < quantity:
		push_error("CANNOT REMOVE MORE ITEMS THAN YOU OWN!")
	
	current_items[type] -= quantity


