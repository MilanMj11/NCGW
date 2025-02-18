extends Node
class_name StatsManager

enum STAT_TYPE {HUNGER, THIRST, HEALTH, SANITY, ENERGY}

var current_stats : Dictionary = {
	STAT_TYPE.HUNGER : 0,
	STAT_TYPE.THIRST : 0,
	STAT_TYPE.HEALTH : 0,
	STAT_TYPE.SANITY : 0,
	STAT_TYPE.ENERGY : 0,
}

@onready var maximum_stats : Dictionary = {
	STAT_TYPE.HUNGER : 6,
	STAT_TYPE.THIRST : 6,
	STAT_TYPE.HEALTH : 10,
	STAT_TYPE.SANITY : 6,
	STAT_TYPE.ENERGY : 10,
}


func _ready():
	set_maximum_stats()
	#pass

func increase_maximum_stat(type: STAT_TYPE, amount: int):
	maximum_stats[type] += amount
	GameEvents.emit_stats_changed()


func decrease_maximum_stat(type: STAT_TYPE, amount: int):
	if maximum_stats[type] < amount:
		push_error("CANNOT DECREASE MAXIMUM STAT WITH MORE THAN YOU HAVE")
	
	maximum_stats[type] -= amount
	GameEvents.emit_stats_changed()


func increase_stat(type: STAT_TYPE, amount: int):
	current_stats[type] += amount
	current_stats[type] = clamp(current_stats[type], 0, maximum_stats[type])
	GameEvents.emit_stats_changed()


func decrease_stat(type: STAT_TYPE, amount: int):
	if current_stats[type] < amount:
		push_error("CANNOT DECREASE CURRENT STAT WITH MORE THAN YOU HAVE")
	
	current_stats[type] -= amount
	GameEvents.emit_stats_changed()


func set_maximum_stats():
	for type in STAT_TYPE:
		current_stats[STAT_TYPE[type]] = maximum_stats[STAT_TYPE[type]]


