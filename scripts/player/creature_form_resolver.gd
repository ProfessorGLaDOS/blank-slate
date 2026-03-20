class_name CreatureFormResolver
extends RefCounted

## Resolves the creature form based on held elements.
## Priority order (GDD 2.3.4):
##   1. Tier 2+ combo override
##   2. Tier 1 combo override
##   3. Dual-element default
##   4. Single-element dominant (>60%)
##   5. Balanced human


static func resolve(held_elements: Array[String]) -> Dictionary:
	if held_elements.is_empty():
		return {"form_id": "human", "body_category": "bipedal", "visual_tier": 0}

	var weights := get_elemental_weights(held_elements)

	# Check for tier 2+ combo overrides first
	for element_id in held_elements:
		var tier := _get_element_tier(element_id)
		if tier >= 2:
			var override := _get_combo_creature_override(element_id)
			if override != "":
				var body_cat := _get_body_category_for_form(override)
				return {"form_id": override, "body_category": body_cat, "visual_tier": tier}

	# Check for tier 1 combo overrides
	for element_id in held_elements:
		var tier := _get_element_tier(element_id)
		if tier == 1:
			var override := _get_combo_creature_override(element_id)
			if override != "":
				var body_cat := _get_body_category_for_form(override)
				return {"form_id": override, "body_category": body_cat, "visual_tier": tier}

	# Dual-element default: find the top two elements by weight
	var sorted_elements := _sort_by_weight(weights)
	if sorted_elements.size() >= 2:
		var a: String = sorted_elements[0]
		var b: String = sorted_elements[1]
		var weight_a: float = weights[a]
		var weight_b: float = weights[b]
		# Only use dual form if neither is overwhelmingly dominant
		if weight_a <= 0.6 and weight_b >= 0.2:
			var dual_form := _get_dual_element_form(a, b)
			if dual_form != "":
				var body_cat := _get_body_category_for_form(dual_form)
				return {"form_id": dual_form, "body_category": body_cat, "visual_tier": 1}

	# Single-element dominant (>60%)
	if sorted_elements.size() >= 1:
		var dominant: String = sorted_elements[0]
		var dominant_weight: float = weights[dominant]
		if dominant_weight > 0.6:
			var single_form := _get_single_element_form(dominant)
			if single_form != "":
				var body_cat := _get_body_category_for_form(single_form)
				return {"form_id": single_form, "body_category": body_cat, "visual_tier": 1}

	# Balanced human fallback
	return {"form_id": "human", "body_category": "bipedal", "visual_tier": 0}


static func get_elemental_weights(held_elements: Array[String]) -> Dictionary:
	var counts: Dictionary = {}
	var total: int = held_elements.size()
	if total == 0:
		return counts

	for element_id in held_elements:
		var base := _get_base_element(element_id)
		if counts.has(base):
			counts[base] += 1
		else:
			counts[base] = 1

	var weights: Dictionary = {}
	for base_element in counts:
		weights[base_element] = float(counts[base_element]) / float(total)
	return weights


static func _get_element_tier(element_id: String) -> int:
	# Tier lookup: base elements are tier 0, combos have higher tiers.
	# This should ideally query the ElementData resource, but we provide a
	# lightweight static mapping for the resolver.
	var tier_map: Dictionary = {
		# Base elements (tier 0)
		"fire": 0, "water": 0, "earth": 0, "lightning": 0,
		"air": 0, "shadow": 0, "light": 0, "void": 0,
		# Tier 1 combos
		"steam": 1, "ice": 1, "magma": 1, "storm": 1,
		"crystal": 1, "nature": 1, "plasma": 1, "eclipse": 1,
		"dust": 1, "mist": 1, "quicksand": 1, "aurora": 1,
		# Tier 2 combos
		"obsidian": 2, "blizzard": 2, "eruption": 2, "supercell": 2,
		"radiant_crystal": 2, "corruption": 2, "rift": 2, "primsatic": 2,
		# Tier 3 combos
		"aether": 3, "entropy": 3, "genesis": 3, "oblivion": 3,
	}
	if tier_map.has(element_id):
		return tier_map[element_id]
	return 0


static func _get_base_element(element_id: String) -> String:
	# Map combo elements back to their dominant base element.
	var base_map: Dictionary = {
		"fire": "fire", "water": "water", "earth": "earth", "lightning": "lightning",
		"air": "air", "shadow": "shadow", "light": "light", "void": "void",
		"steam": "water", "ice": "water", "magma": "fire", "storm": "lightning",
		"crystal": "earth", "nature": "earth", "plasma": "lightning", "eclipse": "shadow",
		"dust": "earth", "mist": "water", "quicksand": "earth", "aurora": "light",
		"obsidian": "earth", "blizzard": "water", "eruption": "fire", "supercell": "lightning",
		"radiant_crystal": "light", "corruption": "shadow", "rift": "void", "primsatic": "light",
		"aether": "light", "entropy": "void", "genesis": "earth", "oblivion": "shadow",
	}
	if base_map.has(element_id):
		return base_map[element_id]
	return element_id


static func _get_combo_creature_override(element_id: String) -> String:
	var overrides: Dictionary = {
		# Tier 1 combo creature overrides
		"steam": "steam_elemental",
		"ice": "frost_wyrm",
		"magma": "magma_golem",
		"storm": "storm_raptor",
		"crystal": "crystal_sentinel",
		"nature": "treant",
		"plasma": "plasma_wraith",
		"eclipse": "eclipse_stalker",
		# Tier 2 combo creature overrides
		"obsidian": "obsidian_colossus",
		"blizzard": "blizzard_hydra",
		"eruption": "eruption_titan",
		"supercell": "supercell_phoenix",
		"radiant_crystal": "radiant_guardian",
		"corruption": "corruption_fiend",
		"rift": "rift_walker",
		"primsatic": "prismatic_dragon",
		# Tier 3 combo creature overrides
		"aether": "aether_seraph",
		"entropy": "entropy_horror",
		"genesis": "genesis_world_tree",
		"oblivion": "oblivion_void_king",
	}
	if overrides.has(element_id):
		return overrides[element_id]
	return ""


static func _get_dual_element_form(element_a: String, element_b: String) -> String:
	# Alphabetical key ordering for consistent lookup
	var key_a := element_a if element_a < element_b else element_b
	var key_b := element_b if element_a < element_b else element_a
	var key := key_a + "_" + key_b

	var dual_forms: Dictionary = {
		"fire_water": "steam_elemental",
		"earth_fire": "magma_golem",
		"air_lightning": "storm_raptor",
		"earth_water": "mud_shambler",
		"fire_lightning": "plasma_wraith",
		"air_fire": "ember_hawk",
		"earth_lightning": "crystal_sentinel",
		"air_water": "mist_phantom",
		"light_shadow": "eclipse_stalker",
		"shadow_void": "abyss_lurker",
		"light_void": "rift_walker",
		"air_earth": "dust_djinn",
		"earth_light": "radiant_golem",
		"fire_shadow": "ash_revenant",
		"lightning_water": "galvanic_eel",
		"air_shadow": "shade_wing",
	}
	if dual_forms.has(key):
		return dual_forms[key]
	return "chimera"


static func _get_single_element_form(element: String) -> String:
	var single_forms: Dictionary = {
		"fire": "flame_drake",
		"water": "tide_serpent",
		"earth": "stone_golem",
		"lightning": "spark_fox",
		"air": "wind_sprite",
		"shadow": "shade_panther",
		"light": "luminous_stag",
		"void": "void_wraith",
	}
	if single_forms.has(element):
		return single_forms[element]
	return "human"


static func _get_body_category_for_form(form_id: String) -> String:
	var category_map: Dictionary = {
		# Single-element forms
		"flame_drake": "quadruped",
		"tide_serpent": "serpentine",
		"stone_golem": "bipedal",
		"spark_fox": "quadruped",
		"wind_sprite": "floating",
		"shade_panther": "quadruped",
		"luminous_stag": "quadruped",
		"void_wraith": "floating",
		# Dual-element forms
		"steam_elemental": "amorphous",
		"magma_golem": "bipedal",
		"storm_raptor": "avian",
		"mud_shambler": "amorphous",
		"plasma_wraith": "floating",
		"ember_hawk": "avian",
		"crystal_sentinel": "bipedal",
		"mist_phantom": "floating",
		"eclipse_stalker": "arachnid",
		"abyss_lurker": "serpentine",
		"rift_walker": "bipedal",
		"dust_djinn": "floating",
		"radiant_golem": "bipedal",
		"ash_revenant": "bipedal",
		"galvanic_eel": "serpentine",
		"shade_wing": "avian",
		"chimera": "bipedal",
		# Tier 1 combo overrides
		"frost_wyrm": "serpentine",
		"treant": "bipedal",
		# Tier 2 combo overrides
		"obsidian_colossus": "bipedal",
		"blizzard_hydra": "serpentine",
		"eruption_titan": "bipedal",
		"supercell_phoenix": "avian",
		"radiant_guardian": "bipedal",
		"corruption_fiend": "arachnid",
		"prismatic_dragon": "quadruped",
		# Tier 3 combo overrides
		"aether_seraph": "avian",
		"entropy_horror": "amorphous",
		"genesis_world_tree": "bipedal",
		"oblivion_void_king": "floating",
		# Fallback
		"human": "bipedal",
	}
	if category_map.has(form_id):
		return category_map[form_id]
	return "bipedal"


static func _sort_by_weight(weights: Dictionary) -> Array:
	var entries: Array = []
	for key in weights:
		entries.append({"element": key, "weight": weights[key]})
	entries.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return a["weight"] > b["weight"]
	)
	var result: Array = []
	for entry in entries:
		result.append(entry["element"])
	return result
