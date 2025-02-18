extends TextureRect

@onready var available : bool = true

@onready var map_available_icon = preload("res://assets/icons/map_icon.png")
@onready var map_hovered_icon = preload("res://assets/icons/map_selected_icon.png")
@onready var map_unavailable_icon = preload("res://assets/icons/map_unavailable_icon.png")


func _ready():
	GameEvents.day_changed.connect(on_day_changed)
	GameEvents.night_settled.connect(on_night_settled)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)


func on_mouse_entered():
	if available == true:
		self.texture = map_hovered_icon


func on_mouse_exited():
	if available == true:
		self.texture = map_available_icon


func on_day_changed(day_nr):
	available = true
	self.texture = map_available_icon


func on_night_settled():
	available = false
	self.texture = map_unavailable_icon
