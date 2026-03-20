class_name RunState
extends RefCounted
## Holds all in-memory data for a single tower run.

# Floor / zone tracking
var current_floor: int = 1
var current_zone_position: int = 1
var zone_elements: Array[String] = []
var zone_biome_variants: Array[String] = []

# Player resources
var held_elements: Array[String] = []  # max 4
var hp: float = 100.0
var max_hp: float = 100.0
var stamina: float = 100.0
var max_stamina: float = 100.0
var essence: int = 0
var consumables: Array[String] = ["", "", ""]

# Run stats
var echoes_earned: int = 0
var enemies_killed: int = 0
var combinations_performed: int = 0

# Visual progression
var current_visual_tier: int = 0
var current_creature_form: String = "stick_figure"

# Combat
var ultimate_charge: float = 0.0

# Tracking
var discovered_combos_this_run: Array[String] = []
var floors_cleared_no_damage: int = 0

# All possible elements
const ALL_ELEMENTS: Array[String] = [
	"Fire", "Water", "Earth", "Lightning", "Air", "Shadow", "Light", "Void"
]

# All possible biome variants
const BIOME_VARIANTS: Array[String] = [
	"cave", "forest", "field", "ruins", "swamp", "mountain", "desert", "tundra"
]


func initialize(save_data: Dictionary) -> void:
	## Sets up a new run, applying any meta-progression bonuses from save_data.
	# Apply armory HP bonus.
	var armory_hp_bonus: float = save_data.get("armory_hp_bonus", 0.0)
	max_hp += armory_hp_bonus
	hp = max_hp

	# Apply stamina forge bonus.
	var stamina_forge_bonus: float = save_data.get("stamina_forge_bonus", 0.0)
	max_stamina += stamina_forge_bonus
	stamina = max_stamina

	# Apply starting essence bonus.
	essence = save_data.get("starting_essence", 0)

	# Reset run tracking.
	current_floor = 1
	current_zone_position = 1
	echoes_earned = 0
	enemies_killed = 0
	combinations_performed = 0
	current_visual_tier = 0
	current_creature_form = "stick_figure"
	ultimate_charge = 0.0
	discovered_combos_this_run.clear()
	floors_cleared_no_damage = 0
	held_elements.clear()
	consumables = ["", "", ""]

	_generate_zones(save_data)


func _generate_zones(save_data: Dictionary) -> void:
	## Generates 4 zones for this run by shuffling unlocked elements and picking biome variants.
	var unlocked_elements: Array = save_data.get("unlocked_elements", []).duplicate()

	# Default to all elements if nothing is unlocked.
	if unlocked_elements.is_empty():
		unlocked_elements = ALL_ELEMENTS.duplicate()

	unlocked_elements.shuffle()

	zone_elements.clear()
	zone_biome_variants.clear()

	var zone_count: int = 4
	for i in range(zone_count):
		# Pick an element for this zone (cycle if fewer unlocked than zones).
		var element_index: int = i % unlocked_elements.size()
		zone_elements.append(unlocked_elements[element_index])

		# Pick a random biome variant.
		var variant: String = BIOME_VARIANTS[randi() % BIOME_VARIANTS.size()]
		zone_biome_variants.append(variant)


func get_current_zone_element() -> String:
	## Returns the element associated with the current zone.
	var zone_index: int = clampi((current_floor - 1) / 5, 0, zone_elements.size() - 1)
	if zone_index < zone_elements.size():
		return zone_elements[zone_index]
	return "Fire"


func get_current_biome_variant() -> String:
	## Returns the biome variant for the current zone.
	var zone_index: int = clampi((current_floor - 1) / 5, 0, zone_biome_variants.size() - 1)
	if zone_index < zone_biome_variants.size():
		return zone_biome_variants[zone_index]
	return "cave"


func can_hold_more_elements() -> bool:
	return held_elements.size() < 4


func add_element(element: String) -> bool:
	if not can_hold_more_elements():
		return false
	held_elements.append(element)
	return true


func use_consumable(slot_index: int) -> String:
	## Uses and clears the consumable at the given slot. Returns the item name or "".
	if slot_index < 0 or slot_index >= consumables.size():
		return ""
	var item: String = consumables[slot_index]
	consumables[slot_index] = ""
	return item


func get_run_summary() -> Dictionary:
	## Returns a dictionary of stats for the death/victory screen.
	return {
		"floor_reached": current_floor,
		"enemies_killed": enemies_killed,
		"echoes_earned": echoes_earned,
		"combinations_performed": combinations_performed,
		"discovered_combos": discovered_combos_this_run.size(),
		"floors_no_damage": floors_cleared_no_damage,
		"creature_form": current_creature_form,
		"visual_tier": current_visual_tier,
	}
