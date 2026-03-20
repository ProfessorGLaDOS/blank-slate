extends Node
## Calculates echo rewards from runs and applies meta-progression bonuses.

# Echo reward table: milestone -> {base_amount, first_bonus}
# first_bonus is added on top of base_amount the first time a milestone is achieved.
var echo_reward_table: Dictionary = {
	"boss_kill": {"base": 10, "first_bonus": 15},
	"flawless_floor": {"base": 5, "first_bonus": 10},
	"new_combo": {"base": 3, "first_bonus": 5},
	"floor_5": {"base": 10, "first_bonus": 20},
	"floor_10": {"base": 20, "first_bonus": 30},
	"floor_15": {"base": 30, "first_bonus": 40},
	"floor_20": {"base": 50, "first_bonus": 50},
	"tower_clear": {"base": 100, "first_bonus": 100},
	"challenge_room": {"base": 8, "first_bonus": 12},
}

# Meta bonus definitions: structure_id -> {stat, per_level, max_level}
var meta_bonus_data: Dictionary = {
	"armory": {"stat": "max_hp_bonus", "per_level": 5, "max_level": 10},
	"stamina_forge": {"stat": "max_stamina_bonus", "per_level": 3, "max_level": 10},
	"echo_well": {"stat": "echo_multiplier", "per_level": 0.05, "max_level": 10},
	"alchemy_lab": {"stat": "combo_potency_bonus", "per_level": 0.02, "max_level": 10},
}


func calculate_run_echoes(run_data: Dictionary) -> int:
	var total_echoes: int = 0
	var achieved_milestones: Array = run_data.get("milestones", [])
	var previously_achieved: Array = SaveManager.get_data("achieved_milestones", [])

	for milestone in achieved_milestones:
		var milestone_id: String = ""
		var count: int = 1

		if milestone is Dictionary:
			milestone_id = milestone.get("id", "")
			count = milestone.get("count", 1)
		elif milestone is String:
			milestone_id = milestone

		if not echo_reward_table.has(milestone_id):
			continue

		var is_first: bool = milestone_id not in previously_achieved
		var reward: int = get_echo_reward(milestone_id, is_first)
		total_echoes += reward * count

		if is_first and milestone_id not in previously_achieved:
			previously_achieved.append(milestone_id)

	# Apply echo well multiplier if available
	var echo_mult: float = SaveManager.get_data("echo_multiplier", 0.0)
	if echo_mult > 0.0:
		total_echoes = int(total_echoes * (1.0 + echo_mult))

	# Store updated milestones
	SaveManager.set_data("achieved_milestones", previously_achieved)

	# Add echoes to save
	var current_echoes: int = SaveManager.get_data("echoes", 0)
	SaveManager.set_data("echoes", current_echoes + total_echoes)
	SaveManager.save()

	return total_echoes


func get_echo_reward(milestone: String, is_first: bool) -> int:
	if not echo_reward_table.has(milestone):
		return 0

	var data: Dictionary = echo_reward_table[milestone]
	var amount: int = data["base"]

	if is_first:
		amount += data["first_bonus"]

	return amount


func apply_meta_bonuses(run_state: Dictionary, save_data: Dictionary) -> Dictionary:
	## Applies all meta-progression bonuses to the run state.
	## Returns the modified run_state with bonuses applied.
	var modified_state: Dictionary = run_state.duplicate(true)
	var built_structures: Dictionary = save_data.get("hub_structures", {})
	var structure_levels: Dictionary = save_data.get("structure_levels", {})

	for structure_id in meta_bonus_data:
		if not built_structures.get(structure_id, false):
			continue

		var bonus_info: Dictionary = meta_bonus_data[structure_id]
		var level: int = structure_levels.get(structure_id, 1)
		level = mini(level, bonus_info["max_level"])

		var stat: String = bonus_info["stat"]
		var bonus_value: float = bonus_info["per_level"] * level

		match stat:
			"max_hp_bonus":
				var base_hp: int = modified_state.get("max_hp", 100)
				modified_state["max_hp"] = base_hp + int(bonus_value)
			"max_stamina_bonus":
				var base_stamina: int = modified_state.get("max_stamina", 50)
				modified_state["max_stamina"] = base_stamina + int(bonus_value)
			"echo_multiplier":
				modified_state["echo_multiplier"] = bonus_value
			"combo_potency_bonus":
				modified_state["combo_potency_bonus"] = bonus_value

	return modified_state


func get_milestone_floor_rewards(highest_floor: int) -> Array[String]:
	## Returns which floor milestones were reached during a run.
	var milestones: Array[String] = []

	if highest_floor >= 5:
		milestones.append("floor_5")
	if highest_floor >= 10:
		milestones.append("floor_10")
	if highest_floor >= 15:
		milestones.append("floor_15")
	if highest_floor >= 20:
		milestones.append("floor_20")

	return milestones
