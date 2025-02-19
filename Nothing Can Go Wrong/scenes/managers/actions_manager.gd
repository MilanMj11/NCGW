extends Node


@onready var chopped_wood : bool = false
@onready var hunted : bool = false
@onready var explored : bool = false
@onready var rested : bool = false


func set_actions(chopped_wood, hunted, explored, rested):
	self.chopped_wood = chopped_wood
	self.hunted = hunted
	self.explored = explored
	self.rested = rested
