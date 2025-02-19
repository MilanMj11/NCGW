extends Node

signal stats_changed
signal items_changed
signal day_changed(day_counter)
signal night_settled
signal decision_menu_closed(energy_consumed)
signal middle_of_night
signal decisions_taken(bitwise_representation)


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
