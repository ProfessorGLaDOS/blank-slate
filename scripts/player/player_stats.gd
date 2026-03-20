extends Node

signal hp_changed(current: float, maximum: float)
signal stamina_changed(current: float, maximum: float)
signal player_died

var hp: float = 100.0
var max_hp: float = 100.0
var stamina: float = 100.0
var max_stamina: float = 100.0

var stamina_regen_rate: float = 15.0
var stamina_regen_delay: float = 1.0

var meta_hp_bonus: float = 0.0

var _stamina_regen_paused: bool = false
var _stamina_timer: float = 0.0


func _process(delta: float) -> void:
	# Handle stamina regeneration
	if _stamina_regen_paused:
		_stamina_timer -= delta
		if _stamina_timer <= 0.0:
			_stamina_regen_paused = false
	else:
		if stamina < max_stamina:
			stamina = minf(stamina + stamina_regen_rate * delta, max_stamina)
			stamina_changed.emit(stamina, max_stamina)


func take_damage(amount: float) -> void:
	hp = maxf(hp - amount, 0.0)
	hp_changed.emit(hp, max_hp)
	if hp <= 0.0:
		player_died.emit()


func heal(amount: float) -> void:
	hp = minf(hp + amount, max_hp)
	hp_changed.emit(hp, max_hp)


func consume_stamina(amount: float) -> void:
	stamina = maxf(stamina - amount, 0.0)
	stamina_changed.emit(stamina, max_stamina)
	_stamina_regen_paused = true
	_stamina_timer = stamina_regen_delay


func apply_hp_modifier(modifier: float) -> void:
	meta_hp_bonus += modifier
	var old_ratio := hp / max_hp if max_hp > 0.0 else 1.0
	max_hp = 100.0 + meta_hp_bonus
	hp = max_hp * old_ratio
	hp_changed.emit(hp, max_hp)
