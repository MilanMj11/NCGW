extends Node

signal stats_changed

func emit_stats_changed():
	stats_changed.emit()
