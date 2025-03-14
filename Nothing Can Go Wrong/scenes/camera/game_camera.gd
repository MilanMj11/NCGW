extends Camera2D

signal camera_centered

@export var SMOOTHING_CONSTANT = 10

@export var camera_mouse_lean : bool = false

@export var random_strength : float = 7.0
@export var shake_fade : float = 6.5 # the higher, the faster it fades

var centered_position : Vector2 = Vector2(303, 156)

var camera_locked : bool = false
var current_shake_strength : float = 0
var rng = RandomNumberGenerator.new()

var target_position = Vector2.ZERO
var player


func _ready():
	make_current()
	connect_to_player()



func apply_shake():
	current_shake_strength = random_strength


func randomOffset():
	return Vector2(rng.randf_range(-current_shake_strength, current_shake_strength), rng.randf_range(-current_shake_strength, current_shake_strength))


func center_camera():
	lock()
	var tween = create_tween()
	tween.tween_property(self, "global_position", centered_position, 0.5)
	await tween.finished
	camera_centered.emit()


func _process(delta):
	if camera_locked == true:
		return
	
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * SMOOTHING_CONSTANT))
	
	# Camera leans towards the mouse ( where player is shooting )
	if camera_mouse_lean == true:
		var mouse_pos = get_global_mouse_position()
		offset = Vector2((mouse_pos.x - player.global_position.x) / (640.0 / 16.0), (mouse_pos.y - player.global_position.y) / (360.0 / 16.0))
	else:
		offset = Vector2.ZERO
	
	if current_shake_strength > 0.1:
		current_shake_strength = lerpf(current_shake_strength, 0, shake_fade * delta)
		offset = offset + randomOffset()
	

func set_camera_mouse_lean(value : bool):
	camera_mouse_lean = value


func lock():
	camera_locked = true

func unlock():
	camera_locked = false


func acquire_target():
	if player == null:
		return
	
	target_position = player.global_position


func connect_to_player():
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
