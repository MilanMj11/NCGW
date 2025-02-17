extends Camera2D

@export var SMOOTHING_CONSTANT = 10

@export var camera_mouse_lean : bool = false

@export var random_strength : float = 7.0
@export var shake_fade : float = 6.5 # the higher, the faster it fades

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


func _process(delta):
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * SMOOTHING_CONSTANT))
	
	# Camera leans towards the mouse ( where player is shooting )
	if camera_mouse_lean == true:
		var mouse_pos = get_global_mouse_position()
		offset = Vector2((mouse_pos.x - player.global_position.x) / (640.0 / 16.0), (mouse_pos.y - player.global_position.y) / (360.0 / 16.0))
	
	if current_shake_strength > 0.1:
		current_shake_strength = lerpf(current_shake_strength, 0, shake_fade * delta)
		offset = offset + randomOffset()
	

func set_camera_mouse_lean(value : bool):
	camera_mouse_lean = value


func acquire_target():
	if player == null:
		return
	
	target_position = player.global_position


func connect_to_player():
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
