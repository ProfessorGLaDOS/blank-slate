class_name DamageEvent
extends RefCounted

var base_damage: float = 0.0
var element: String = ""
var source: Node = null
var status_effect: String = ""
var status_duration: float = 0.0
var knockback_force: float = 0.0
var knockback_direction: Vector2 = Vector2.ZERO
var is_combo_reaction: bool = false


func _init(
	p_base_damage: float = 0.0,
	p_element: String = "",
	p_source: Node = null
) -> void:
	base_damage = p_base_damage
	element = p_element
	source = p_source
