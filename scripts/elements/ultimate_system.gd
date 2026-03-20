extends Node

signal ultimate_charged
signal ultimate_used
signal charge_changed(current: float, max_charge: float)

var current_ultimate: Resource = null  # UltimateData
var charge: float = 0.0
var charge_max: float = 100.0
var is_active: bool = false

var _active_timer: float = 0.0
var _channel_timer: float = 0.0


func _process(delta: float) -> void:
	if is_active and current_ultimate != null:
		var ult: UltimateData = current_ultimate as UltimateData
		if ult == null:
			return

		match ult.activation_type:
			"transformation":
				_active_timer -= delta
				if _active_timer <= 0.0:
					_deactivate()
			"channel":
				_channel_timer -= delta
				if _channel_timer <= 0.0:
					_deactivate()
			"field":
				_active_timer -= delta
				if _active_timer <= 0.0:
					_deactivate()

		# Timed buildup charge type accumulates passively
		if ult.charge_type == "timed_buildup" and not is_active:
			add_charge(delta * 10.0)


func set_ultimate(data: Resource) -> void:
	current_ultimate = data
	charge = 0.0
	is_active = false
	_active_timer = 0.0
	_channel_timer = 0.0
	if data != null:
		var ult := data as UltimateData
		if ult != null:
			charge_max = ult.charge_threshold
		else:
			charge_max = 100.0
	else:
		charge_max = 100.0
	charge_changed.emit(charge, charge_max)


func add_charge(amount: float) -> void:
	if is_active:
		return
	var previous := charge
	charge = clampf(charge + amount, 0.0, charge_max)
	if charge != previous:
		charge_changed.emit(charge, charge_max)
	if charge >= charge_max and previous < charge_max:
		ultimate_charged.emit()


func try_activate() -> bool:
	if current_ultimate == null:
		return false
	if is_active:
		return false
	if charge < charge_max:
		return false

	var ult := current_ultimate as UltimateData
	if ult == null:
		return false

	# Apply HP cost if sacrifice type
	if ult.hp_cost_percent > 0.0:
		# The caller should handle HP deduction via the signal
		pass

	match ult.activation_type:
		"instant":
			_activate_instant(ult)
		"transformation":
			_activate_transformation(ult)
		"channel":
			_activate_channel(ult)
		"summon":
			_activate_summon(ult)
		"field":
			_activate_field(ult)
		"sacrifice":
			_activate_sacrifice(ult)
		_:
			_activate_instant(ult)

	charge = 0.0
	charge_changed.emit(charge, charge_max)
	ultimate_used.emit()
	return true


func on_damage_dealt(amount: float) -> void:
	if current_ultimate == null or is_active:
		return
	var ult := current_ultimate as UltimateData
	if ult != null and ult.charge_type == "damage_dealt":
		add_charge(amount * 0.1)


func on_damage_taken(amount: float) -> void:
	if current_ultimate == null or is_active:
		return
	var ult := current_ultimate as UltimateData
	if ult != null and ult.charge_type == "damage_taken":
		add_charge(amount * 0.2)


func on_combo_reaction() -> void:
	if current_ultimate == null or is_active:
		return
	var ult := current_ultimate as UltimateData
	if ult != null and ult.charge_type == "combo_reactions":
		add_charge(15.0)


func on_kill() -> void:
	if current_ultimate == null or is_active:
		return
	var ult := current_ultimate as UltimateData
	if ult != null and ult.charge_type == "kill_streak":
		add_charge(20.0)


func on_ability_used() -> void:
	if current_ultimate == null or is_active:
		return
	var ult := current_ultimate as UltimateData
	if ult != null and ult.charge_type == "elemental_saturation":
		add_charge(5.0)


func _activate_instant(_ult: UltimateData) -> void:
	is_active = true
	# Instant ultimates fire and immediately deactivate
	_deactivate()


func _activate_transformation(ult: UltimateData) -> void:
	is_active = true
	_active_timer = ult.duration


func _activate_channel(ult: UltimateData) -> void:
	is_active = true
	_channel_timer = ult.channel_time


func _activate_summon(_ult: UltimateData) -> void:
	is_active = true
	# Summon logic handled externally via script_override or signals
	_deactivate()


func _activate_field(ult: UltimateData) -> void:
	is_active = true
	_active_timer = ult.duration


func _activate_sacrifice(_ult: UltimateData) -> void:
	is_active = true
	# HP cost applied by caller; effect is instant
	_deactivate()


func _deactivate() -> void:
	is_active = false
	_active_timer = 0.0
	_channel_timer = 0.0
