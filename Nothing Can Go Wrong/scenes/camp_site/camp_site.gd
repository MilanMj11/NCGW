extends Node2D


func _ready():
	%Fireplace.find_child("AnimationPlayer").play("burn")
