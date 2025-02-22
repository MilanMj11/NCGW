extends Node

signal stats_changed
signal items_changed
signal day_changed(day_counter)
signal night_settled
signal decision_menu_closed(energy_consumed)
signal middle_of_night
signal decisions_taken(bitwise_representation)
signal can_sleep
signal lost_all_sanity
signal flaregun_fired

@onready var seed_val

func _ready():
	seed_val = randi()


func set_global_seed(seed_value):
	seed(seed_value)
	seed_val = seed_value


func reset_global_seed():
	seed(seed_val)


func emit_stats_changed():
	stats_changed.emit()


func emit_items_changed():
	items_changed.emit()


func emit_day_changed(day_counter: int):
	day_changed.emit(day_counter)


func emit_night_settled():
	night_settled.emit()


func emit_decision_menu_closed(energy_consumed):
	decision_menu_closed.emit(energy_consumed)


func emit_middle_of_night():
	middle_of_night.emit()


func emit_decisions_taken(bitwise_representation):
	decisions_taken.emit(bitwise_representation)


func emit_can_sleep():
	can_sleep.emit()


func emit_lost_all_sanity():
	lost_all_sanity.emit()


func emit_flaregun_fired():
	flaregun_fired.emit()
