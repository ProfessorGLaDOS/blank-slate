extends Node

const BUFFER_WINDOW: float = 0.15

var buffer: Dictionary = {}

var _combat_actions: Array[String] = [
	"attack",
	"dash",
	"ability_1",
	"ability_2",
	"ability_3",
	"ability_4",
	"interact",
]


func _input(event: InputEvent) -> void:
	if not event.is_pressed():
		return
	for action in _combat_actions:
		if event.is_action(action):
			buffer[action] = Time.get_ticks_msec() / 1000.0


func consume(action: String) -> bool:
	if not buffer.has(action):
		return false

	var current_time: float = Time.get_ticks_msec() / 1000.0
	var press_time: float = buffer[action]

	if current_time - press_time <= BUFFER_WINDOW:
		buffer.erase(action)
		return true

	buffer.erase(action)
	return false


func clear_all() -> void:
	buffer.clear()
