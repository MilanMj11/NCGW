extends Node

@onready var helpers_come : bool = false

func _ready():
	GameEvents.flaregun_fired.connect(on_flaregun_fired)


func return_to_main_menu():
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


func on_flaregun_fired():
	helpers_come = true
