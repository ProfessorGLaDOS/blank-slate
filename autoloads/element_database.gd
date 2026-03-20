extends Node

var elements: Dictionary = {}
var combinations: Array[Dictionary] = []


func _ready() -> void:
	_register_base_elements()
	_register_combinations()


func get_element(id: String) -> Dictionary:
	if elements.has(id):
		return elements[id]
	push_warning("ElementDatabase: Unknown element id: " + id)
	return {}


func get_combinations_for(element_ids: Array) -> Array[Dictionary]:
	var results: Array[Dictionary] = []
	for combo in combinations:
		for input_id in combo["inputs"]:
			if input_id in element_ids:
				results.append(combo)
				break
	return results


func can_combine(a: String, b: String) -> Dictionary:
	for combo in combinations:
		var inputs: Array = combo["inputs"]
		if inputs.size() == 2:
			if (inputs[0] == a and inputs[1] == b) or (inputs[0] == b and inputs[1] == a):
				return combo
	return {}


func _register_base_elements() -> void:
	_add_element("FIRE", "Fire", "The primordial flame.", Color.ORANGE_RED, 0)
	_add_element("WATER", "Water", "The flowing current.", Color.DODGER_BLUE, 0)
	_add_element("AIR", "Air", "The unseen breath.", Color.LIGHT_CYAN, 0)
	_add_element("EARTH", "Earth", "The unyielding stone.", Color.SADDLE_BROWN, 0)
	_add_element("LIGHT", "Light", "The radiant dawn.", Color.GOLD, 0)
	_add_element("DARK", "Dark", "The consuming void.", Color.DARK_VIOLET, 0)


func _add_element(id: String, display_name: String, description: String, color: Color, tier: int) -> void:
	elements[id] = {
		"id": id,
		"name": display_name,
		"description": description,
		"color": color,
		"tier": tier,
	}


func _register_combinations() -> void:
	# Fire combinations
	_add_combo(["FIRE", "WATER"], "STEAM", "Steam", "Scalding vapor.", Color.LIGHT_GRAY, 1)
	_add_combo(["FIRE", "AIR"], "LIGHTNING", "Lightning", "The crackling strike.", Color.YELLOW, 1)
	_add_combo(["FIRE", "EARTH"], "MAGMA", "Magma", "Molten fury.", Color.DARK_ORANGE, 1)
	_add_combo(["FIRE", "LIGHT"], "RADIANCE", "Radiance", "Blinding brilliance.", Color.WHITE, 1)
	_add_combo(["FIRE", "DARK"], "ASH", "Ash", "Smoldering remains.", Color.DIM_GRAY, 1)

	# Water combinations
	_add_combo(["WATER", "AIR"], "ICE", "Ice", "Frozen stillness.", Color.LIGHT_BLUE, 1)
	_add_combo(["WATER", "EARTH"], "MUD", "Mud", "Clinging mire.", Color.DARK_GOLDENROD, 1)
	_add_combo(["WATER", "LIGHT"], "CRYSTAL", "Crystal", "Prismatic clarity.", Color.AQUAMARINE, 1)
	_add_combo(["WATER", "DARK"], "POISON", "Poison", "Toxic corruption.", Color.PURPLE, 1)

	# Air combinations
	_add_combo(["AIR", "EARTH"], "SAND", "Sand", "The eroding gale.", Color.TAN, 1)
	_add_combo(["AIR", "LIGHT"], "AURORA", "Aurora", "Celestial ribbons.", Color.GREEN_YELLOW, 1)
	_add_combo(["AIR", "DARK"], "SMOKE", "Smoke", "Choking obscurity.", Color.SLATE_GRAY, 1)

	# Earth combinations
	_add_combo(["EARTH", "LIGHT"], "METAL", "Metal", "Forged resilience.", Color.SILVER, 1)
	_add_combo(["EARTH", "DARK"], "GRAVITY", "Gravity", "Crushing weight.", Color.DARK_SLATE_GRAY, 1)

	# Light + Dark
	_add_combo(["LIGHT", "DARK"], "ECLIPSE", "Eclipse", "The balance of opposites.", Color.MEDIUM_PURPLE, 1)


func _add_combo(inputs: Array, result_id: String, display_name: String, description: String, color: Color, tier: int) -> void:
	# Register the resulting element if not already registered
	if not elements.has(result_id):
		_add_element(result_id, display_name, description, color, tier)

	combinations.append({
		"inputs": inputs,
		"result": result_id,
	})
