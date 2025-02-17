extends CanvasLayer

@export var StatsManager : StatsManager

@onready var stat_to_container_dict : Dictionary = {
	StatsManager.STAT_TYPE.HEALTH : %HealthBarsContainer,
	StatsManager.STAT_TYPE.ENERGY : %EnergyBarsContainer,
	StatsManager.STAT_TYPE.SANITY : %SanityBarsContainer,
	StatsManager.STAT_TYPE.HUNGER : %HungerBarsContainer,
	StatsManager.STAT_TYPE.THIRST : %ThirstBarsContainer
}

@onready var stat_to_bar_dict : Dictionary = {
	StatsManager.STAT_TYPE.HEALTH : [preload("res://assets/UI_images/health_bar_point.png"), preload("res://assets/UI_images/health_bar_empty.png")],
	StatsManager.STAT_TYPE.ENERGY : [preload("res://assets/UI_images/energy_bar_point.png"), preload("res://assets/UI_images/energy_bar_empty.png")],
	StatsManager.STAT_TYPE.SANITY : [preload("res://assets/UI_images/sanity_bar_point.png"), preload("res://assets/UI_images/sanity_bar_empty.png")],
	StatsManager.STAT_TYPE.HUNGER : [preload("res://assets/UI_images/hunger_bar_point.png"), preload("res://assets/UI_images/hunger_bar_empty.png")],
	StatsManager.STAT_TYPE.THIRST : [preload("res://assets/UI_images/thirst_bar_point.png"), preload("res://assets/UI_images/thirst_bar_empty.png")]
}


func _ready():
	# connect_to_stats_manager()
	GameEvents.stats_changed.connect(update_hud)
	Callable(update_hud).call_deferred()


func update_hud():
	# Update each stat's bar
	for type in StatsManager.STAT_TYPE:
		var key = StatsManager.STAT_TYPE[type]
		
		var full_bars_count = StatsManager.current_stats[key]
		var empty_bars_count = StatsManager.maximum_stats[key] - StatsManager.current_stats[key]
		
		var full_bar_TextureRect : TextureRect = TextureRect.new()
		var empty_bar_TextureRect : TextureRect = TextureRect.new()
		
		full_bar_TextureRect.texture = stat_to_bar_dict[key][0]
		empty_bar_TextureRect.texture = stat_to_bar_dict[key][1]
		
		var container = stat_to_container_dict[key]
		
		for child in container.get_children():
			child.queue_free()
		
		for i in range(full_bars_count):
			var new_full_bar_TextureRect = full_bar_TextureRect.duplicate()
			container.add_child(new_full_bar_TextureRect)
		
		for i in range(empty_bars_count):
			var new_empty_bar_TextureRect = empty_bar_TextureRect.duplicate()
			container.add_child(new_empty_bar_TextureRect)
		


func connect_to_stats_manager():
	StatsManager = get_tree().get_first_node_in_group("stats_manager")
