extends Node


func trigger(duration: float = 0.05) -> void:
	Engine.time_scale = 0.0
	var timer := get_tree().create_timer(duration, true, false, true)
	await timer.timeout
	Engine.time_scale = 1.0
