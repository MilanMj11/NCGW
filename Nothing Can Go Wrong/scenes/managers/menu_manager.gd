extends Node

signal transition_finished

@onready var test_menu_scene = preload("res://scenes/menu/test_menu.tscn")
@onready var inventory_menu = preload("res://scenes/menu/inventory_menu.tscn")
@onready var decisions_menu = preload("res://scenes/menu/decisions_menu.tscn")
@onready var rewards_menu = preload("res://scenes/menu/rewards_menu.tscn")
@onready var end_of_game_menu = preload("res://scenes/menu/end_of_game_menu.tscn")
@onready var lost_menu = preload("res://scenes/menu/lost_menu.tscn")
@onready var died_menu = preload("res://scenes/menu/died_menu.tscn")

var main_node : Node
var current_menu_node : Node


func _ready():
	connect_to_main_node()
	connect_to_current_menu_node()


func show_menu(menu_scene: PackedScene, do_nothing : bool = false):
	%ColorRect.visible = true
	$AnimationPlayer.play("in")
	var menu = menu_scene.instantiate()
	if do_nothing == true:
		menu.do_nothing = true
	current_menu_node.add_child(menu)
	
	var slide_tween = get_tree().create_tween()
	slide_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	menu.offset = Vector2(0, -400)
	slide_tween.tween_property(menu, "offset", Vector2(0, 0), 0.25)
	
	get_tree().paused = true
	
	await slide_tween.finished
	transition_finished.emit()


func show_test_menu():
	show_menu(test_menu_scene)


func show_inventory_menu():
	show_menu(inventory_menu)


func show_decisions_menu():
	show_menu(decisions_menu)


func show_rewards_menu():
	show_menu(rewards_menu)


func show_end_of_game_menu():
	show_menu(end_of_game_menu)


func show_lost_menu():
	show_menu(lost_menu)


func show_died_menu():
	show_menu(died_menu)



func remove_menu():
	for child in current_menu_node.get_children():
		child.queue_free()
	
	get_tree().paused = false
	
	$AnimationPlayer.play_backwards("in")
	await $AnimationPlayer.animation_finished
	%ColorRect.visible = true


func connect_to_main_node():
	main_node = get_tree().root.get_node("Main")


func connect_to_current_menu_node():
	current_menu_node = main_node.find_child("CurrentMenu")
