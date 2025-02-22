extends Node2D

signal ambient_sound_stopped

var sound_effects_types = {}  # Conversion from type to actual sound effect
@export var sound_effects_list: Array[SoundEffect]

var current_ambient_sound

func _ready():
	for sound_effect : SoundEffect in sound_effects_list:
		sound_effects_types[sound_effect.type] = sound_effect


func play_sound_at_position(sound_global_position: Vector2, type: SoundEffect.SOUND_EFFECT_TYPE):
	if !sound_effects_types.has(type):
		print("SOUND EFFECT TYPE NOT FOUND!")
		return
	
	var sound_effect : SoundEffect = sound_effects_types[type]
	var audio_2d = AudioStreamPlayer2D.new()
	add_child(audio_2d)
	
	audio_2d.global_position = sound_global_position
	audio_2d.stream = sound_effect.stream_sounds.pick_random()
	audio_2d.volume_db = sound_effect.volume
	
	audio_2d.pitch_scale = 1.0
	if sound_effect.randomize_pitch == true:
		audio_2d.pitch_scale = randf_range(sound_effect.min_pitch, sound_effect.max_pitch)
	
	audio_2d.finished.connect(audio_2d.queue_free)
	
	audio_2d.play()
	
	return audio_2d


func play_ambient_sound(type: SoundEffect.SOUND_EFFECT_TYPE):
	if !sound_effects_types.has(type):
		print("SOUND EFFECT TYPE NOT FOUND!")
		return
	
	var sound_effect : SoundEffect = sound_effects_types[type]
	
	stop_ambient_sound()
	await ambient_sound_stopped
	
	current_ambient_sound = AudioStreamPlayer2D.new()
	add_child(current_ambient_sound)
	
	current_ambient_sound.stream = sound_effect.stream_sounds.pick_random()
	current_ambient_sound.volume_db = -50
	
	current_ambient_sound.finished.connect(on_ambient_sound_finished.bind(sound_effect.type))
	current_ambient_sound.play()
	
	var tween = create_tween()
	tween.tween_property(current_ambient_sound, "volume_db", sound_effect.volume, 2.0)


func on_ambient_sound_finished(ambient_sound_type):
	play_ambient_sound(ambient_sound_type)


func stop_ambient_sound():
	if current_ambient_sound:
		# Face fade-out la sunetul curent
		var tween = create_tween()
		tween.tween_property(current_ambient_sound, "volume_db", -80, 1.0)
		
		await tween.finished
		
		current_ambient_sound.stop()
		current_ambient_sound.queue_free()
		current_ambient_sound = null
		
		ambient_sound_stopped.emit()
	else:
		await get_tree().create_timer(1).timeout
		ambient_sound_stopped.emit()
