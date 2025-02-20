extends Node

signal enemies_stopped_spawning

@onready var enemy_scene = preload("res://scenes/enemy/enemy.tscn")
@onready var enemies_spawning : bool = true
var radius_range = [170, 220]


func _ready():
	GameEvents.middle_of_night.connect(spawn_enemies)
	var fireplace = get_tree().get_first_node_in_group("fireplace")
	fireplace.fireplace_extinguished.connect(on_fireplace_extinguished)
	fireplace.fireplace_lighted.connect(on_fireplace_lighted)
	$FastTimer.timeout.connect(on_timer_timeout)
	$SlowTimer.timeout.connect(on_timer_timeout)
	$TotalTimer.timeout.connect(on_total_timer_timeout)


func spawn_random_enemy():
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	var campsite = get_tree().get_first_node_in_group("campsite")
	
	var random_direction : Vector2 = Vector2(randf_range(-1, 1), randf_range(-0.6, 0.6)).normalized()
	var fireplace_position = campsite.find_child("Fireplace").global_position
	var spawn_position = fireplace_position + random_direction * randf_range(radius_range[0], radius_range[1])
	spawn_position.y = clamp(spawn_position.y, fireplace_position.y - 140, fireplace_position.y + 140)
	
	var enemy_instance = enemy_scene.instantiate() as Node2D
	enemy_instance.global_position = spawn_position
	
	enemy_instance.look_at(fireplace_position)
	enemy_instance.rotation += deg_to_rad(-90)
	
	entities_layer.add_child(enemy_instance)


func spawn_enemies():
	$TotalTimer.start()


func on_timer_timeout():
	# whenever one of the 2 timers stop , we check if we are in the middle of the "gamemode"
	# middle of the "gamemode" means the TotalTimer is running
	if $TotalTimer.time_left > 0:
		spawn_random_enemy()


func on_fireplace_extinguished():
	$SlowTimer.stop()
	$FastTimer.start()


func on_fireplace_lighted():
	$SlowTimer.start()
	$FastTimer.stop()


func on_total_timer_timeout():
	enemies_stopped_spawning.emit()
	enemies_spawning = false
	var player = get_tree().get_first_node_in_group("player")
	player.sanity_induction = max(0, player.sanity_induction - 40)
