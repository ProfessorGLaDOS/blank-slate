class_name StatusEffectManager
extends Node

signal effect_applied(effect_name: String)
signal effect_removed(effect_name: String)


class StatusEffectInstance:
	var effect_name: String = ""
	var remaining: float = 0.0
	var stacks: int = 1
	var source_element: String = ""

	func _init(p_name: String = "", p_duration: float = 0.0, p_source: String = "") -> void:
		effect_name = p_name
		remaining = p_duration
		source_element = p_source


# Maps effect_name -> StatusEffectInstance
var active_effects: Dictionary = {}

# Stacking rules: max stacks per effect
const STACK_LIMITS: Dictionary = {
	"burning": 10,
	"poisoned": 5,
	"frozen": 1,
	"entangled": 1,
	"cursed": 1,
	"blessed": 1,
	"shocked": 1,
}

# Combo reaction table: {existing_effect: {incoming_element: reaction_name}}
const COMBO_REACTIONS: Dictionary = {
	"frozen": {"fire": "shatter"},
	"burning": {"water": "steam_burst"},
	"poisoned": {"fire": "toxic_ignition"},
	"shocked": {"water": "conduction"},
	"entangled": {"air": "uproot"},
	"cursed": {"light": "purge"},
	"blinded": {"dark": "terror"},
}


func apply_effect(effect_name: String, duration: float, source_element: String) -> void:
	# Check for combo reactions before applying
	_check_combo_reactions(effect_name, source_element)

	var max_stacks: int = STACK_LIMITS.get(effect_name, 1)

	if active_effects.has(effect_name):
		var existing: StatusEffectInstance = active_effects[effect_name]

		if max_stacks > 1 and existing.stacks < max_stacks:
			# Stackable effect: increase stacks and refresh duration
			existing.stacks += 1
			existing.remaining = duration
		elif max_stacks == 1:
			# Non-stackable: refresh duration (frozen, entangled, cursed, blessed)
			# Shocked doesn't stack and doesn't refresh
			if effect_name != "shocked":
				existing.remaining = duration
		# If at max stacks, just refresh duration
		else:
			existing.remaining = duration
	else:
		var instance := StatusEffectInstance.new(effect_name, duration, source_element)
		active_effects[effect_name] = instance
		effect_applied.emit(effect_name)


func _process(delta: float) -> void:
	var expired: Array[String] = []

	for effect_name: String in active_effects:
		var effect: StatusEffectInstance = active_effects[effect_name]
		effect.remaining -= delta
		if effect.remaining <= 0.0:
			expired.append(effect_name)

	for effect_name: String in expired:
		active_effects.erase(effect_name)
		effect_removed.emit(effect_name)


func _check_combo_reactions(incoming_effect: String, incoming_element: String) -> void:
	if incoming_element.is_empty():
		return

	# Check if any active effect reacts with the incoming element
	var reactions_to_trigger: Array[Dictionary] = []

	for effect_name: String in active_effects:
		if COMBO_REACTIONS.has(effect_name):
			var element_map: Dictionary = COMBO_REACTIONS[effect_name]
			if element_map.has(incoming_element):
				var reaction_name: String = element_map[incoming_element]
				reactions_to_trigger.append({
					"effect": effect_name,
					"reaction": reaction_name,
				})

	for reaction: Dictionary in reactions_to_trigger:
		var effect_name: String = reaction["effect"]
		var reaction_name: String = reaction["reaction"]
		# Remove the consumed effect
		active_effects.erase(effect_name)
		effect_removed.emit(effect_name)
		# Signal the combo reaction (listeners can handle the actual effect)
		print("[StatusEffectManager] Combo reaction triggered: %s" % reaction_name)


func has_effect(effect_name: String) -> bool:
	return active_effects.has(effect_name)


func get_stacks(effect_name: String) -> int:
	if active_effects.has(effect_name):
		return active_effects[effect_name].stacks
	return 0


func clear_all() -> void:
	var all_effects: Array = active_effects.keys()
	active_effects.clear()
	for effect_name: String in all_effects:
		effect_removed.emit(effect_name)
