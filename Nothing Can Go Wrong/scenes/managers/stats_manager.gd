extends Node
class_name StatsManager

enum STAT_TYPE {HUNGER, THIRST, HEALTH, SANITY, ENERGY}

var current_stats : Dictionary = {
	STAT_TYPE.HUNGER : 5,
	STAT_TYPE.THIRST : 5,
	STAT_TYPE.HEALTH : 10,
	STAT_TYPE.SANITY : 1,
	STAT_TYPE.ENERGY : 10,
}

@onready var maximum_stats : Dictionary = {
	STAT_TYPE.HUNGER : 6,
	STAT_TYPE.THIRST : 6,
	STAT_TYPE.HEALTH : 10,
	STAT_TYPE.SANITY : 6,
	STAT_TYPE.ENERGY : 10,
}

@onready var stat_to_icon : Dictionary = {
	STAT_TYPE.HUNGER : preload("res://assets/icons/hunger_icon.png"),
	STAT_TYPE.THIRST : preload("res://assets/icons/water_icon.png"),
	STAT_TYPE.HEALTH : preload("res://assets/icons/health_icon.png"),
	STAT_TYPE.SANITY : preload("res://assets/icons/sanity_icon.png"),
	STAT_TYPE.ENERGY : preload("res://assets/icons/energy_icon.png")
}


func _ready():
	#set_maximum_stats()
	pass


func increase_maximum_stat(type: STAT_TYPE, amount: int):
	maximum_stats[type] += amount
	GameEvents.emit_stats_changed()


func decrease_maximum_stat(type: STAT_TYPE, amount: int):
	if maximum_stats[type] < amount:
		push_error("CANNOT DECREASE MAXIMUM STAT WITH MORE THAN YOU HAVE")
	
	maximum_stats[type] -= amount
	maximum_stats[type] = clamp(maximum_stats[type], 0, 15)
	GameEvents.emit_stats_changed()


func increase_stat(type: STAT_TYPE, amount: int):
	current_stats[type] += amount
	current_stats[type] = clamp(current_stats[type], 0, maximum_stats[type])
	GameEvents.emit_stats_changed()


func decrease_stat(type: STAT_TYPE, amount: int):
	#if current_stats[type] < amount:
		#push_error("CANNOT DECREASE CURRENT STAT WITH MORE THAN YOU HAVE")
	
	if current_stats[type] == 0:
		return
	
	current_stats[type] -= amount
	current_stats[type] = clamp(current_stats[type], 0, maximum_stats[type])
	
	if current_stats[STAT_TYPE.SANITY] < 6:
		maximum_stats[STAT_TYPE.ENERGY] = min(10 - (6 - current_stats[STAT_TYPE.SANITY]), maximum_stats[STAT_TYPE.ENERGY])
		current_stats[STAT_TYPE.ENERGY] = min(maximum_stats[STAT_TYPE.ENERGY], current_stats[STAT_TYPE.ENERGY])
	
	
	if type == STAT_TYPE.SANITY and current_stats[STAT_TYPE.SANITY] == 0:
		GameEvents.emit_lost_all_sanity()
	
	GameEvents.emit_stats_changed()



func set_maximum_stats():
	for type in STAT_TYPE:
		current_stats[STAT_TYPE[type]] = maximum_stats[STAT_TYPE[type]]


