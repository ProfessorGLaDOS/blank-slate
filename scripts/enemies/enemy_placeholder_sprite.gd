extends Node2D

## Simple colored circle placeholder for enemy visuals.

@export var radius: float = 8.0
@export var color: Color = Color(0.6, 0.15, 0.15, 1.0)


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)
	# Outline
	draw_arc(Vector2.ZERO, radius, 0, TAU, 32, Color.BLACK, 1.5)
