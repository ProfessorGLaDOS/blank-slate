extends Node2D

var current_form_id: String = "stick_figure"
var current_visual_tier: int = 0
var current_body_category: String = "bipedal"
var element_tint: Color = Color.WHITE

@onready var stick_figure: Node2D = $StickFigure

var _is_transitioning: bool = false


func _ready() -> void:
	modulate = Color.WHITE


func transition_to_form(new_form_id: String, duration: float = 1.5) -> void:
	if _is_transitioning:
		return
	_is_transitioning = true

	var half_duration := duration * 0.5

	# Dissolve out: fade to transparent
	var dissolve_tween := create_tween()
	dissolve_tween.tween_property(self, "modulate:a", 0.0, half_duration)
	await dissolve_tween.finished

	# Switch form
	current_form_id = new_form_id
	# Future: swap child nodes or visibility based on form_id

	# Reform in: fade back to full with optional tint
	var reform_tween := create_tween()
	reform_tween.tween_property(self, "modulate:a", 1.0, half_duration)
	await reform_tween.finished

	_is_transitioning = false


func apply_element_tint(tint_color: Color) -> void:
	element_tint = tint_color
	# Apply as a faint color wash (lerp toward tint at 30% strength for Tier 0->1)
	var wash := Color.WHITE.lerp(tint_color, 0.3)
	var tint_tween := create_tween()
	tint_tween.tween_property(self, "modulate", wash, 0.5)
