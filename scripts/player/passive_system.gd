extends Node
## Manages the player's active passive ability.
## Only one passive can be active at a time.
## See GDD 2.3.6 / TIG 6B for full passive descriptions.

var active_passive: String = ""
var passive_handlers: Dictionary = {}


func _ready() -> void:
	passive_handlers = {
		"adaptable": _activate_adaptable,
		"trample": _activate_trample,
		"constrict": _activate_constrict,
		"web_sense": _activate_web_sense,
		"airborne": _activate_airborne,
		"absorption": _activate_absorption,
		"hover": _activate_hover,
		"endurance": _activate_endurance,
		"construct": _activate_construct,
		"flutter": _activate_flutter,
	}


func activate(passive_id: String) -> bool:
	if not passive_handlers.has(passive_id):
		push_warning("PassiveSystem: Unknown passive '%s'" % passive_id)
		return false

	if active_passive != "":
		deactivate()

	active_passive = passive_id
	var handler: Callable = passive_handlers[passive_id]
	handler.call()
	return true


func deactivate() -> void:
	if active_passive == "":
		return

	# Remove all passive effects from the player
	_clear_all_passive_effects()
	active_passive = ""


func get_active_passive() -> String:
	return active_passive


func is_passive_active(passive_id: String) -> bool:
	return active_passive == passive_id


func _clear_all_passive_effects() -> void:
	# TODO: Remove any stat modifiers, timers, or signals connected by the active passive.
	pass


func _activate_adaptable() -> void:
	# Adaptable: Player gains a small bonus to the element type most recently picked up.
	# Increases affinity with the last collected element, boosting damage of that type.
	# Full implementation: track last element pickup, apply +15% damage buff for that element.
	pass


func _activate_trample() -> void:
	# Trample: Moving through enemies deals contact damage proportional to player speed.
	# Faster movement = more damage on contact. Does not interrupt player movement.
	# Full implementation: add collision callback that deals speed * 0.5 damage on overlap.
	pass


func _activate_constrict() -> void:
	# Constrict: Enemies that stay within melee range for 2+ seconds take escalating DOT.
	# Damage ticks every 0.5s, increasing by 10% per tick while the enemy remains close.
	# Full implementation: track per-enemy proximity timers, apply stacking DOT.
	pass


func _activate_web_sense() -> void:
	# Web Sense: Reveals hidden traps, secret rooms, and enemy positions through walls.
	# Grants a minimap overlay showing nearby threats and points of interest.
	# Full implementation: enable fog-of-war pierce, highlight trap tiles, show enemy pings.
	pass


func _activate_airborne() -> void:
	# Airborne: Player can dash over pits and hazard tiles without taking damage.
	# Grants brief invulnerability frames during dash, ignoring ground-based hazards.
	# Full implementation: set hazard_immune flag during dash state, extend dash i-frames by 0.2s.
	pass


func _activate_absorption() -> void:
	# Absorption: Blocking or taking hits has a chance to absorb the element used against you.
	# 20% chance on hit to gain 1 unit of the attacking element. Does not reduce damage taken.
	# Full implementation: hook into damage_taken signal, roll chance, add element to inventory.
	pass


func _activate_hover() -> void:
	# Hover: Player floats slightly above ground, reducing movement speed penalty on rough terrain.
	# Ignores slow tiles (mud, sand, ice friction). Movement speed is consistent across all surfaces.
	# Full implementation: override terrain speed modifiers, set ground_type_immune flag.
	pass


func _activate_endurance() -> void:
	# Endurance: Stamina regeneration rate increased by 30%. Stamina costs reduced by 10%.
	# Stacks additively with stamina forge meta-progression bonuses.
	# Full implementation: modify stamina_regen_rate and stamina_cost_multiplier on player stats.
	pass


func _activate_construct() -> void:
	# Construct: Player can place a temporary barrier once every 15 seconds.
	# Barrier has HP equal to 25% of player max HP, blocks enemy movement and projectiles.
	# Full implementation: add barrier ability with cooldown timer, spawn barrier scene on use.
	pass


func _activate_flutter() -> void:
	# Flutter: After dodging, gain a brief speed boost (+25% move speed for 1.5 seconds).
	# Triggers on successful dodge/dash. Does not stack; refreshes duration on consecutive dodges.
	# Full implementation: connect to dodge_completed signal, apply temporary speed buff.
	pass
