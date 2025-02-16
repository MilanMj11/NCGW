extends CanvasLayer

signal transitioned_halfway
signal transition_finished

var skip_emit = false

func transition(focus_position: Vector2 = Vector2(-320, -180)):
	$ColorRect.position = focus_position
	$AnimationPlayer.play("default")
	await transitioned_halfway
	# When we transitioned the scene already the player will always be in the middle of the screen
	# The player pivot offset is a bit off so it doesn't look like it's perfectly centered on the player
	$ColorRect.position = Vector2(-320, -180)
	$AnimationPlayer.play_backwards("default")
	await $AnimationPlayer.animation_finished
	transition_finished.emit()


func emit_transitioned_halfway():
	if skip_emit:
		skip_emit = false
		return
	transitioned_halfway.emit()
