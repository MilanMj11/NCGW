extends Node2D

var sound_effects_types = {}  # Conversion from type to actual sound effect
@export var sound_effects_list: Array[SoundEffect]


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
	
