extends Node

signal stats_changed
signal items_changed
signal day_changed(day_counter)
signal night_settled


func emit_stats_changed():
	stats_changed.emit()


func emit_items_changed():
	items_changed.emit()


func emit_day_changed(day_counter: int):
	day_changed.emit(day_counter)


func emit_night_settled():
	night_settled.emit()
