extends Node

var main_node : Node
var current_scene_node : Node

func _ready():
	connect_to_main_node()
	connect_to_current_scene_node()


func get_player_screen_position():
	var player = get_tree().get_first_node_in_group("player")
	var camera = main_node.find_child("GameCamera")
	# The 16 is an offset for the player height
	return - Vector2(320, 180) + Vector2((player.position.x - camera.position.x),-(camera.position.y - player.position.y + 16))


func switch_scene(new_scene: PackedScene):
	
	var player = get_tree().get_first_node_in_group("player")
	
	# Play the out transition and pause the tree
	ScreenTransition.transition(get_player_screen_position())
	get_tree().paused = true
	
	await ScreenTransition.transitioned_halfway
	
	var effect_nodes_node = get_tree().get_first_node_in_group("effect_layer")
	effect_nodes_node.reparent(main_node)
	player.reparent(main_node)
	
	
	# If there is a scene already loaded, we remove it
	for child in current_scene_node.get_children():
		child.queue_free()
	
	
	var new_scene_instance = new_scene.instantiate()
	current_scene_node.add_child(new_scene_instance)
	
	# Put the GameCamera on top of the player
	main_node.find_child("GameCamera").position = player.global_position
	
	# Once the transition finished we can unpause the tree
	get_tree().paused = false
	await ScreenTransition.transition_finished
	
	# NEEDS FIXING , NOT SURE HOW ELSE I CAN MAKE IT , .READY signal DOES NOT WORK
	# Wait until the scene is loaded ( ready ) 
	await get_tree().create_timer(0.2).timeout
	
	# Now we manage the newly added scene
	var actual_scene = current_scene_node.get_child(0)
	
	# Add back the EffectNodes and Player
	effect_nodes_node.reparent(actual_scene)
	player.reparent(actual_scene.find_child("Entities"))
	
	# Make sure the EffectNodes is before the Entities in the scene child order for Y-Sorting
	actual_scene.move_child(effect_nodes_node, actual_scene.find_child("Entities").get_index())
	


func connect_to_main_node():
	main_node = get_tree().root.get_node("Main")


func connect_to_current_scene_node():
	current_scene_node = main_node.find_child("CurrentScene")
