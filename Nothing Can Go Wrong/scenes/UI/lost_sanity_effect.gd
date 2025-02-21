extends CanvasLayer

@onready var time_value : float = 0.0

func _ready():
	$ColorRect.visible = false
	set_process(false)
	GameEvents.lost_all_sanity.connect(on_lost_all_sanity)
	

func _process(delta):
	time_value += 1 * delta / 8
	$ColorRect.material.set_shader_parameter("time", time_value)


func on_lost_all_sanity():
	$ColorRect.visible = true
	$AnimationPlayer.play("start_hallucination")
	await $AnimationPlayer.animation_finished
	set_process(true)
