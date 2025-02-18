extends Node

signal stats_changed
signal items_changed


func emit_stats_changed():
	stats_changed.emit()


func emit_items_changed():
	items_changed.emit()
