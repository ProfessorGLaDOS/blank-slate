extends Node2D

@onready var label: Label = $Label

const FLOAT_DISTANCE: float = 40.0
const FLOAT_DURATION: float = 0.8
const FADE_DELAY: float = 0.3

const ELEMENT_COLORS: Dictionary = {
	"fire": Color(1.0, 0.4, 0.1),
	"water": Color(0.2, 0.6, 1.0),
	"earth": Color(0.6, 0.4, 0.2),
	"lightning": Color(1.0, 1.0, 0.3),
	"air": Color(0.7, 0.9, 1.0),
	"shadow": Color(0.5, 0.2, 0.7),
	"light": Color(1.0, 1.0, 0.8),
	"void": Color(0.3, 0.0, 0.4),
}

var _start_position: Vector2 = Vector2.ZERO
var _elapsed: float = 0.0


func setup(damage: float, element: String = "", is_combo: bool = false) -> void:
	if label == null:
		await ready

	label.text = str(int(damage))

	if is_combo:
		label.add_theme_color_override("font_color", Color.YELLOW)
		label.add_theme_font_size_override("font_size", 20)
	elif ELEMENT_COLORS.has(element):
		label.add_theme_color_override("font_color", ELEMENT_COLORS[element])
	else:
		label.add_theme_color_override("font_color", Color.WHITE)


func _ready() -> void:
	_start_position = position
	_elapsed = 0.0

	# Add slight horizontal randomness
	var offset_x: float = randf_range(-10.0, 10.0)
	_start_position.x += offset_x
	position = _start_position

	# Create float and fade tween
	var tween: Tween = create_tween()
	tween.set_parallel(true)

	# Float upward
	tween.tween_property(
		self, "position:y",
		_start_position.y - FLOAT_DISTANCE,
		FLOAT_DURATION
	).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	# Fade out after delay
	tween.tween_property(
		self, "modulate:a",
		0.0,
		FLOAT_DURATION - FADE_DELAY
	).set_delay(FADE_DELAY).set_ease(Tween.EASE_IN)

	# Queue free after animation completes
	tween.chain().tween_callback(queue_free)
