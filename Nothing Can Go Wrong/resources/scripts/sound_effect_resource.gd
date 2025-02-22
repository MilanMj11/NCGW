extends Resource
class_name SoundEffect

enum SOUND_EFFECT_TYPE {
	FOREST_DAY,
	FOREST_NIGHT,
	WHISPER,
	BUTTON_PRESSED,
	FLASHLIGHT,
	FIRE,
	MAP
}


@export var type: SOUND_EFFECT_TYPE
@export var stream_sounds: Array[AudioStream]
@export var randomize_pitch: bool = true
@export var volume: float = 1.0  # decibels
@export var min_pitch: float = 0.9
@export var max_pitch: float = 1.1
