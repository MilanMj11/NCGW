extends CanvasLayer
class_name RewardsMenu

@onready var positive_action_messages : Dictionary = {
	"chopped_wood" : ["You've gathered plenty of wood to keep your fire going yet another night.",
					   "More firewood collected — you're stocking up well.",
					   "You've secured extra wood. Staying safe won’t be a problem — for now.",
					   "Your firewood count is going up, but will it be enough?"],
	"hunted" : ["Your hunt was successful — you've secured meat and water for now.",
				"Fresh meat and river water added to your supplies.",
				"The hunt went well. You’ve got enough meat and water to last a while."],
	"explored" : ["You've seen some footsteps, followed them and found some objects that might come in handy.",
				  "Your exploration paid off — you found a lost backpack with some batteries and a medkit inside.",
				  "Luck is on your side — a lost backpack with some useful items was hidden in a bush"],
	"rested" : ["You took a moment to breathe, regaining some energy and clarity.",
				"You let yourself unwind today. Energy restored, sanity improving.",
				"You rested well. Strength returned, and the creeping madness faded — for now."]
}

@onready var neutral_action_messages : Dictionary = {
	"explored" : [ "You explored a section of the forest but came up empty-handed.",
				   "You covered some ground, but found nothing useful.",
				   "The forest seems unusual, but nothing found while exploring."]
}

@onready var negative_action_messages : Dictionary = {
	"chopped_wood" : ["While gathering wood, you slipped and cut yourself. Some bandages might be needed.",
					   "You miscalculated a swing, and now you’re nursing a nasty wound."],
	"hunted" : ["While hunting, a wild creature lashed out at you. You got away, but you're bleeding.",
				"In the heat of the hunt, you ran into sharp thorns. Your arms are scratched up pretty badly."],
	"explored" : ["A sharp branch scraped your arm. It’s not deep, but it stings.",
				  "You tripped over a fallen log and bruised yourself. Careful out there."],
	"rested" : ["You tried to rest, but unsettling noises kept you on edge. Sanity maintains the same for now."]
}


@onready var gathered_sanity : int = 0
@onready var gathered_energy : int = 0
@onready var gathered_wood : int = 0
@onready var gathered_food : int = 0
@onready var gathered_water : int = 0
@onready var gathered_battery : int = 0
@onready var gathered_medkit : int = 0
@onready var gathered_flaregun : int = 0
@onready var used_hunger : int = 0
@onready var used_thirst  : int = 0
@onready var used_health : int = 0

@onready var chopped_wood : bool = false
@onready var hunted : bool = false
@onready var explored : bool = false
@onready var rested : bool = false

@onready var health_lost_chopping : int = 0
@onready var health_lost_hunting : int = 0
@onready var health_lost_exploring : int = 0

var initial_hunger
var initial_thirst

var message : String = ""
@onready var do_nothing : bool = false


func _ready():
	if do_nothing == true:
		return
	
	determine_outcome()
	construct_message()
	update_stats_and_items()
	update_images()
	$AnimationPlayer.play("write_message")
	%ConfirmButton.pressed.connect(on_confirm_button_pressed)


func update_images():
	var stats_manager = get_tree().get_first_node_in_group("stats_manager")
	var item_manager = get_tree().get_first_node_in_group("item_manager")
	
	# Plus Containers
	var plus_containers_count = 0
	if gathered_wood > 0:
		plus_containers_count += 1
		var container_name = "PlusContainer" + str(plus_containers_count)
		var container_node = find_child(container_name)
		container_node.visible = true
		container_node.find_child("Label").text = "+" + str(gathered_wood)
		container_node.find_child("TextureRect").texture = item_manager.item_to_icon[item_manager.ITEM_TYPE.WOOD]
	
	if gathered_food > 0:
		plus_containers_count += 1
		var container_name = "PlusContainer" + str(plus_containers_count)
		var container_node = find_child(container_name)
		container_node.visible = true
		container_node.find_child("Label").text = "+" + str(gathered_food)
		container_node.find_child("TextureRect").texture = item_manager.item_to_icon[item_manager.ITEM_TYPE.RAW_FOOD]
	
	if gathered_water > 0:
		plus_containers_count += 1
		var container_name = "PlusContainer" + str(plus_containers_count)
		var container_node = find_child(container_name)
		container_node.visible = true
		container_node.find_child("Label").text = "+" + str(gathered_water)
		container_node.find_child("TextureRect").texture = item_manager.item_to_icon[item_manager.ITEM_TYPE.WATER]
	
	if gathered_battery > 0:
		plus_containers_count += 1
		var container_name = "PlusContainer" + str(plus_containers_count)
		var container_node = find_child(container_name)
		container_node.visible = true
		container_node.find_child("Label").text = "+" + str(gathered_battery)
		container_node.find_child("TextureRect").texture = item_manager.item_to_icon[item_manager.ITEM_TYPE.BATTERY]
	
	if gathered_flaregun > 0:
		plus_containers_count += 1
		var container_name = "PlusContainer" + str(plus_containers_count)
		var container_node = find_child(container_name)
		container_node.visible = true
		container_node.find_child("Label").text = "+" + str(gathered_flaregun)
		container_node.find_child("TextureRect").texture = item_manager.item_to_icon[item_manager.ITEM_TYPE.FLAREGUN]
	
	if gathered_medkit > 0:
		plus_containers_count += 1
		var container_name = "PlusContainer" + str(plus_containers_count)
		var container_node = find_child(container_name)
		container_node.visible = true
		container_node.find_child("Label").text = "+" + str(gathered_medkit)
		container_node.find_child("TextureRect").texture = item_manager.item_to_icon[item_manager.ITEM_TYPE.MEDKIT]
	
	if gathered_sanity > 0:
		plus_containers_count += 1
		var container_name = "PlusContainer" + str(plus_containers_count)
		var container_node = find_child(container_name)
		container_node.visible = true
		container_node.find_child("Label").text = "+" + str(gathered_sanity)
		container_node.find_child("TextureRect").texture = stats_manager.stat_to_icon[stats_manager.STAT_TYPE.SANITY]
	
	if gathered_energy > 0:
		plus_containers_count += 1
		var container_name = "PlusContainer" + str(plus_containers_count)
		var container_node = find_child(container_name)
		container_node.visible = true
		container_node.find_child("Label").text = "+" + str(gathered_energy)
		container_node.find_child("TextureRect").texture = stats_manager.stat_to_icon[stats_manager.STAT_TYPE.ENERGY]
	
	for i in range(plus_containers_count, %PlusContainerBIG.get_child_count()):
		%PlusContainerBIG.get_child(i).visible = false
	
	
	# Minus Containers
	var minus_container_count = 0
	if used_health > 0:
		minus_container_count += 1
		var container_name = "MinusContainer" + str(minus_container_count)
		var container_node = find_child(container_name)
		container_node.visible = true
		container_node.find_child("Label").text = "-" + str(used_health)
		container_node.find_child("TextureRect").texture = stats_manager.stat_to_icon[stats_manager.STAT_TYPE.HEALTH]
	
	if used_hunger > 0:
		minus_container_count += 1
		var container_name = "MinusContainer" + str(minus_container_count)
		var container_node = find_child(container_name)
		container_node.visible = true
		var actual_used_hunger = min(used_hunger, initial_hunger)
		container_node.find_child("Label").text = "-" + str(actual_used_hunger)
		container_node.find_child("TextureRect").texture = stats_manager.stat_to_icon[stats_manager.STAT_TYPE.HUNGER]
	
	if used_thirst > 0:
		minus_container_count += 1
		var container_name = "MinusContainer" + str(minus_container_count)
		var container_node = find_child(container_name)
		container_node.visible = true
		var actual_used_thirst = min(used_thirst, initial_thirst)
		container_node.find_child("Label").text = "-" + str(actual_used_thirst)
		container_node.find_child("TextureRect").texture = stats_manager.stat_to_icon[stats_manager.STAT_TYPE.THIRST]
	
	for i in range(minus_container_count, %MinusContainerBIG.get_child_count()):
		%MinusContainerBIG.get_child(i).visible = false


func update_stats_and_items():
	var stats_manager = get_tree().get_first_node_in_group("stats_manager")
	var item_manager = get_tree().get_first_node_in_group("item_manager")
	
	# Items:
	item_manager.add_items(item_manager.ITEM_TYPE.WOOD, gathered_wood)
	item_manager.add_items(item_manager.ITEM_TYPE.RAW_FOOD, gathered_food)
	item_manager.add_items(item_manager.ITEM_TYPE.WATER, gathered_water)
	item_manager.add_items(item_manager.ITEM_TYPE.BATTERY, gathered_battery)
	item_manager.add_items(item_manager.ITEM_TYPE.MEDKIT, gathered_medkit)
	item_manager.add_items(item_manager.ITEM_TYPE.FLAREGUN, gathered_flaregun)
	
	# Stats:
	stats_manager.decrease_stat(stats_manager.STAT_TYPE.HUNGER, used_hunger)
	stats_manager.decrease_stat(stats_manager.STAT_TYPE.THIRST, used_thirst)
	stats_manager.decrease_stat(stats_manager.STAT_TYPE.HEALTH, used_health)
	stats_manager.increase_stat(stats_manager.STAT_TYPE.SANITY, gathered_sanity)
	stats_manager.increase_stat(stats_manager.STAT_TYPE.ENERGY, gathered_energy)



func construct_message():
	# depending on stats gained and used, we display the messages.
	if gathered_sanity == 0 and gathered_energy > 0:
		message += negative_action_messages["rested"].pick_random() + '\n' + '\n'
	if gathered_sanity > 0 and gathered_energy > 0:
		message += positive_action_messages["rested"].pick_random() + '\n' + '\n'
	
	# Firstly the positive messages.
	if gathered_wood > 0:
		message += positive_action_messages["chopped_wood"].pick_random() + '\n' + '\n'
	
	if gathered_food > 0 or gathered_water > 0:
		message += positive_action_messages["hunted"].pick_random() + '\n' + '\n'
	
	if explored:
		if gathered_battery > 0 or gathered_medkit > 0 or gathered_flaregun > 0:
			message += positive_action_messages["explored"].pick_random() + '\n' + '\n'
		else:
			message += neutral_action_messages["explored"].pick_random() + '\n' + '\n'
	
	if used_health > 0:
		if health_lost_chopping:
			message += negative_action_messages["chopped_wood"].pick_random() + '\n' + '\n'
		if health_lost_hunting:
			message += negative_action_messages["hunted"].pick_random() + '\n' + '\n'
		if health_lost_exploring:
			message += negative_action_messages["explored"].pick_random() + '\n' + '\n'
	
	%MessageLabel.text = message


func determine_outcome():
	var actions_manager = get_tree().get_first_node_in_group("actions_manager")
	
	if actions_manager.chopped_wood == true:
		chopped_wood = true
		gathered_wood += randi_range(3, 4)
		
		used_hunger += randi_range(2, 3)
		used_thirst += randi_range(1, 2)
		
		var used_health_choices = [0, 0, 0, 1, 2]
		health_lost_chopping = used_health_choices[randi() % used_health_choices.size()]
		used_health += health_lost_chopping
		
		
	
	if actions_manager.hunted == true:
		hunted = true
		gathered_food += randi_range(2, 3)
		gathered_water += randi_range(2, 4)
		
		used_hunger += randi_range(1, 2)
		used_thirst += randi_range(2, 3)
		
		var used_health_choices = [0, 0, 0, 1, 1, 1, 2, 3]
		health_lost_hunting = used_health_choices[randi() % used_health_choices.size()]
		used_health += health_lost_hunting
	
	if actions_manager.explored == true:
		explored = true
		var found_backpack_choices = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1]
		var gathered_backpack = found_backpack_choices[randi() % found_backpack_choices.size()]
		if gathered_backpack == 1:
			gathered_battery += randi_range(1, 2)
			gathered_medkit += randi_range(0, 1)
			var found_flaregun_choices = [0, 0, 1]
			
			var day_night_manager = get_tree().get_first_node_in_group("day_night_manager")
			if day_night_manager.current_day < 5:
				found_flaregun_choices = [0]
			
			gathered_flaregun += found_flaregun_choices[randi() % found_flaregun_choices.size()]
		
		used_hunger += randi_range(1, 2)
		used_thirst += randi_range(1, 2)
		
		var used_health_choices = [0, 0, 0, 0, 1]
		health_lost_exploring = used_health_choices[randi() % used_health_choices.size()]
		used_health += health_lost_exploring
	
	
	if actions_manager.rested == true:
		rested = true
		gathered_sanity = randi_range(0, 2)
		gathered_energy += randi_range(2, 4)
		
		used_hunger += 1
		used_thirst += 1
	
	var stats_manager = get_tree().get_first_node_in_group("stats_manager")
	initial_hunger = stats_manager.current_stats[stats_manager.STAT_TYPE.HUNGER]
	if stats_manager.current_stats[stats_manager.STAT_TYPE.HUNGER] - used_hunger < 0:
		used_health += randi_range(1, (-1 * (stats_manager.current_stats[stats_manager.STAT_TYPE.HUNGER] - used_hunger)))

	initial_thirst = stats_manager.current_stats[stats_manager.STAT_TYPE.THIRST]
	if stats_manager.current_stats[stats_manager.STAT_TYPE.THIRST] - used_thirst < 0:
		used_health += randi_range(1, (-1 * (stats_manager.current_stats[stats_manager.STAT_TYPE.THIRST] - used_hunger)))
	

	var died = (stats_manager.current_stats[stats_manager.STAT_TYPE.HEALTH] - used_health) <= 0
	
	return died



func on_confirm_button_pressed():
	var menu_manager = get_tree().get_first_node_in_group("menu_manager")
	menu_manager.remove_menu()

