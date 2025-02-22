extends TextureRect

@onready var available : bool = true

@onready var map_available_icon = preload("res://assets/icons/map_icon.png")
@onready var map_hovered_icon = preload("res://assets/icons/map_selected_icon.png")
@onready var map_unavailable_icon = preload("res://assets/icons/map_unavailable_icon.png")

@onready var menu_shown : bool = false

func _ready():
	GameEvents.day_changed.connect(on_day_changed)
	GameEvents.night_settled.connect(on_night_settled)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)


func _process(delta):
	var current_menu_node = get_tree().get_first_node_in_group("current_menu")
	if current_menu_node.get_child_count() == 0:
		menu_shown = false


func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and available and !menu_shown:
		AudioManager.play_sound_at_position(Vector2(0, 0), SoundEffect.SOUND_EFFECT_TYPE.MAP)
		var menu_manager = get_tree().get_first_node_in_group("menu_manager")
		menu_manager.show_decisions_menu()
		menu_shown = true


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
