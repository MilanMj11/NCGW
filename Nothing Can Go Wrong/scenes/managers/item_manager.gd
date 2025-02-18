extends Node

enum ITEM_TYPE {RAW_FOOD, COOKED_FOOD, WATER, WOOD, FLASHLIGHT, FLAREGUN, BATTERY, MEDKIT}

@onready var current_items : Dictionary = {
	ITEM_TYPE.RAW_FOOD : 0,
	ITEM_TYPE.COOKED_FOOD : 0,
	ITEM_TYPE.WATER : 0,
	ITEM_TYPE.WOOD : 0,
	ITEM_TYPE.FLASHLIGHT : 0,
	ITEM_TYPE.FLAREGUN : 0,
	ITEM_TYPE.BATTERY : 0,
	ITEM_TYPE.MEDKIT : 0
}


@onready var interactable_items : Array = [ITEM_TYPE.COOKED_FOOD, ITEM_TYPE.WATER, ITEM_TYPE.FLAREGUN, ITEM_TYPE.BATTERY, ITEM_TYPE.MEDKIT]

@onready var items_to_interaction_message : Dictionary = {
	ITEM_TYPE.COOKED_FOOD : "Eat",
	ITEM_TYPE.WATER : "Drink",
	ITEM_TYPE.FLAREGUN : "Call for Help",
	ITEM_TYPE.BATTERY : "Reload Flashlight",
	ITEM_TYPE.MEDKIT : "Heal"
}


@onready var item_to_icon : Dictionary = {
	ITEM_TYPE.RAW_FOOD : preload("res://assets/icons/food_icon.png"),
	ITEM_TYPE.COOKED_FOOD : preload("res://assets/icons/cooked_food_icon.png"),
	ITEM_TYPE.WATER : preload("res://assets/icons/bottle_of_water_icon.png"),
	ITEM_TYPE.WOOD : preload("res://assets/icons/wood_icon.png"),
	ITEM_TYPE.FLASHLIGHT : preload("res://assets/icons/flashlight_icon.png"),
	ITEM_TYPE.FLAREGUN : preload("res://assets/icons/flaregun_icon.png"),
	ITEM_TYPE.BATTERY : preload("res://assets/icons/battery_icon.png"),
	ITEM_TYPE.MEDKIT : preload("res://assets/icons/medkit_icon.png")
}


@onready var item_to_name : Dictionary = {
	ITEM_TYPE.RAW_FOOD : "Raw food",
	ITEM_TYPE.COOKED_FOOD : "Cooked food",
	ITEM_TYPE.WATER : "Water bottle",
	ITEM_TYPE.WOOD : "Wood log",
	ITEM_TYPE.FLASHLIGHT : "Flashlight",
	ITEM_TYPE.FLAREGUN : "Flare gun",
	ITEM_TYPE.BATTERY : "Battery",
	ITEM_TYPE.MEDKIT : "Medkit"
}


func _ready():
	#Callable(add_items.bind(ITEM_TYPE.FLASHLIGHT, 1)).call_deferred()
	add_items(ITEM_TYPE.FLASHLIGHT, 1)
	add_items(ITEM_TYPE.WATER, 3)
	add_items(ITEM_TYPE.COOKED_FOOD, 4)
	add_items(ITEM_TYPE.MEDKIT, 5)
	add_items(ITEM_TYPE.WOOD, 7)
	add_items(ITEM_TYPE.RAW_FOOD, 3)
	add_items(ITEM_TYPE.FLAREGUN, 1)
	add_items(ITEM_TYPE.BATTERY, 3)



func add_items(type: ITEM_TYPE, quantity: int = 1):
	current_items[type] += quantity
	GameEvents.emit_items_changed()


func remove_items(type: ITEM_TYPE, quantity: int = 1):
	if current_items[type] < quantity:
		push_error("CANNOT REMOVE MORE ITEMS THAN YOU OWN!")
	
	current_items[type] -= quantity
	GameEvents.emit_items_changed()


