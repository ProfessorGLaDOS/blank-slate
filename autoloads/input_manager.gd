extends Node

signal input_device_changed(device_type: String)

var using_controller: bool = false


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if not using_controller:
			using_controller = true
			input_device_changed.emit("controller")
	elif event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion:
		if using_controller:
			using_controller = false
			input_device_changed.emit("keyboard_mouse")
