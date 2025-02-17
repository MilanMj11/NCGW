extends CanvasLayer

@export var StatsManager : StatsManager

@onready var stat_to_container_dict : Dictionary = {
	StatsManager.STAT_TYPE.HEALTH : %HealthBarsContainer
}


func _ready():
	# connect_to_stats_manager()
	GameEvents.stats_changed.connect(update_hud)
	for type in StatsManager.STAT_TYPE:
		# print(StatsManager.STAT_TYPE[type])
		if stat_to_container_dict.has(StatsManager.STAT_TYPE[type]):
			print(stat_to_container_dict[StatsManager.STAT_TYPE[type]].name)


func update_hud():
	# Update each stat's bar
	pass



func connect_to_stats_manager():
	StatsManager = get_tree().get_first_node_in_group("stats_manager")
