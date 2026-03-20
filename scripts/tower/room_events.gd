extends Node
## Handles special room interactions: shrines, altars, merchants, and rest shrines.

signal element_chosen(element: String)
signal combination_performed(result: String)
signal item_purchased(item_name: String)
signal rest_completed(heal_amount: float, buff: String)

## All available elements in the game.
const ALL_ELEMENTS: Array[String] = [
	"Fire", "Water", "Earth", "Lightning", "Air", "Shadow", "Light", "Void"
]

## Minor passive buffs available at rest shrines.
const REST_BUFFS: Array[String] = [
	"speed_boost",
	"attack_boost",
	"defense_boost",
	"stamina_regen",
	"hp_regen",
	"element_magnet",
]


# ---------------------------------------------------------------------------
# Shrine: present 2-3 element choices, player picks one
# ---------------------------------------------------------------------------

func generate_shrine_choices(held_elements: Array[String], count: int = 3) -> Array[String]:
	## Returns 2-3 element options not already held by the player.
	var available: Array[String] = []
	for elem in ALL_ELEMENTS:
		if elem not in held_elements:
			available.append(elem)

	available.shuffle()

	var choice_count: int = clampi(count, 2, mini(3, available.size()))
	var choices: Array[String] = []
	for i in range(choice_count):
		choices.append(available[i])

	return choices


func apply_shrine_choice(run_state: RefCounted, chosen_element: String) -> bool:
	## Adds the chosen element to the run state if there is room (max 4).
	## Returns true on success.
	if run_state.held_elements.size() >= 4:
		return false
	run_state.held_elements.append(chosen_element)
	element_chosen.emit(chosen_element)
	return true


# ---------------------------------------------------------------------------
# Altar: detect combinable elements, offer combination
# ---------------------------------------------------------------------------

func get_combinable_pairs(held_elements: Array[String]) -> Array:
	## Returns an array of dictionaries with keys: "element_a", "element_b", "result".
	## Phase 1: simple pair-based combinations.
	var combos: Array = []
	var combo_table: Dictionary = {
		"Fire+Water": "Steam",
		"Fire+Earth": "Magma",
		"Fire+Air": "Inferno",
		"Water+Earth": "Mud",
		"Water+Lightning": "Storm",
		"Lightning+Air": "Tempest",
		"Shadow+Light": "Eclipse",
		"Earth+Void": "Gravity",
		"Light+Fire": "Radiance",
		"Shadow+Void": "Oblivion",
	}

	for i in range(held_elements.size()):
		for j in range(i + 1, held_elements.size()):
			var a: String = held_elements[i]
			var b: String = held_elements[j]
			var key_ab: String = a + "+" + b
			var key_ba: String = b + "+" + a
			if combo_table.has(key_ab):
				combos.append({
					"element_a": a,
					"element_b": b,
					"result": combo_table[key_ab],
				})
			elif combo_table.has(key_ba):
				combos.append({
					"element_a": b,
					"element_b": a,
					"result": combo_table[key_ba],
				})

	return combos


func perform_combination(run_state: RefCounted, element_a: String, element_b: String, result: String) -> bool:
	## Removes the two source elements and adds the result.
	## Returns true on success.
	var idx_a: int = run_state.held_elements.find(element_a)
	var idx_b: int = run_state.held_elements.find(element_b)
	if idx_a == -1 or idx_b == -1:
		return false

	# Remove in reverse index order to avoid shifting issues.
	if idx_a > idx_b:
		run_state.held_elements.remove_at(idx_a)
		run_state.held_elements.remove_at(idx_b)
	else:
		run_state.held_elements.remove_at(idx_b)
		run_state.held_elements.remove_at(idx_a)

	run_state.held_elements.append(result)
	run_state.combinations_performed += 1
	combination_performed.emit(result)
	return true


# ---------------------------------------------------------------------------
# Merchant: display items for purchase with Essence
# ---------------------------------------------------------------------------

func get_merchant_inventory() -> Array:
	## Returns an array of dictionaries with keys: "name", "description", "cost".
	var inventory: Array = [
		{"name": "Health Potion", "description": "Restores 30 HP", "cost": 50},
		{"name": "Stamina Tonic", "description": "Restores 25 Stamina", "cost": 40},
		{"name": "Element Magnet", "description": "Increases pickup range for 1 floor", "cost": 75},
		{"name": "Shield Charm", "description": "Blocks the next hit", "cost": 100},
		{"name": "Speed Boots", "description": "Move 20% faster for 1 floor", "cost": 60},
	]
	# Shuffle and return a subset of 3 items.
	inventory.shuffle()
	return inventory.slice(0, 3)


func purchase_item(run_state: RefCounted, item: Dictionary) -> bool:
	## Attempts to purchase an item. Returns true if successful.
	var cost: int = item.get("cost", 0)
	if run_state.essence < cost:
		return false

	run_state.essence -= cost

	# Try to place in an empty consumable slot.
	for i in range(run_state.consumables.size()):
		if run_state.consumables[i] == "":
			run_state.consumables[i] = item.get("name", "")
			item_purchased.emit(item.get("name", ""))
			return true

	# No empty slots.
	return false


# ---------------------------------------------------------------------------
# Rest Shrine: heal 30% max HP, choose a minor passive buff
# ---------------------------------------------------------------------------

func get_rest_buff_choices(count: int = 3) -> Array[String]:
	## Returns a selection of minor passive buffs to choose from.
	var shuffled: Array[String] = REST_BUFFS.duplicate()
	shuffled.shuffle()
	var result: Array[String] = []
	for i in range(mini(count, shuffled.size())):
		result.append(shuffled[i])
	return result


func apply_rest(run_state: RefCounted, chosen_buff: String) -> void:
	## Heals the player for 30% of max HP and applies the chosen buff.
	var heal_amount: float = run_state.max_hp * 0.3
	run_state.hp = minf(run_state.hp + heal_amount, run_state.max_hp)
	rest_completed.emit(heal_amount, chosen_buff)
