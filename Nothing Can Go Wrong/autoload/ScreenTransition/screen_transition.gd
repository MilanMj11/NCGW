extends CanvasLayer

signal transitioned_halfway
signal transition_finished

signal transitioned_first_half
signal transitioned_second_half

var skip_emit = false

func transition(focus_position: Vector2 = Vector2(-1280, -720)):
	$ColorRect.position = focus_position
	$AnimationPlayer.play("default")
	await transitioned_halfway
	# When we transitioned the scene already the player will always be in the middle of the screen
	# The player pivot offset is a bit off so it doesn't look like it's perfectly centered on the player
	# $ColorRect.position = Vector2(-320, -180)
	$AnimationPlayer.play_backwards("default")
	await $AnimationPlayer.animation_finished
	transition_finished.emit()


func transition_first_half(focus_position: Vector2 = Vector2(0, 0)):
	$ColorRect.position = focus_position
	$AnimationPlayer.play("default")
	await $AnimationPlayer.animation_finished
	transitioned_first_half.emit()


func no_animation(focus_position: Vector2 = Vector2(0, 0)):
	$ColorRect.position = focus_position
	$AnimationPlayer.play("no_animation")
	await $AnimationPlayer.animation_finished
	transitioned_first_half.emit()


func transition_second_half(focus_position: Vector2 = Vector2(0, 0)):
	$ColorRect.position = focus_position
	$AnimationPlayer.play_backwards("default")
	await $AnimationPlayer.animation_finished
	transitioned_second_half.emit()


func emit_transitioned_halfway():
	if skip_emit:
		skip_emit = false
		return
	transitioned_halfway.emit()
