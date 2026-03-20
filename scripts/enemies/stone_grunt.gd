extends "res://scripts/enemies/enemy_base.gd"

# Stone Grunt - Phase 1 basic melee enemy
# Slow, predictable, telegraphed attacks

enum State { PATROL, CHASE, ATTACK }

# Override base stats
@export var essence_drop: int = 2

var _state: State = State.PATROL
var _patrol_target: Vector2 = Vector2.ZERO
var _patrol_timer: float = 0.0
var _patrol_interval: float = 3.0
var _attack_phase: int = 0  # 0=idle, 1=telegraphing, 2=striking
var _attack_timer: float = 0.0
var _room_center: Vector2 = Vector2.ZERO
var _room_extents: Vector2 = Vector2(200, 200)


func _ready() -> void:
	# Set stone grunt stats
	max_hp = 30.0
	hp = 30.0
	move_speed = 80.0
	detection_radius = 150.0
	attack_damage = 10.0
	attack_cooldown = 1.5
	attack_range = 25.0
	telegraph_duration = 0.4

	super._ready()
	_room_center = global_position
	_pick_patrol_target()


func _tick_behavior(delta: float) -> void:
	match _state:
		State.PATROL:
			_tick_patrol(delta)
		State.CHASE:
			_tick_chase(delta)
		State.ATTACK:
			_tick_attack(delta)


func _tick_patrol(delta: float) -> void:
	# Transition to chase if player detected
	if target != null:
		_state = State.CHASE
		return

	# Wander to patrol point
	_patrol_timer -= delta
	if _patrol_timer <= 0.0:
		_pick_patrol_target()

	var direction: Vector2 = (_patrol_target - global_position).normalized()
	var distance: float = global_position.distance_to(_patrol_target)

	if distance > 5.0:
		velocity = direction * move_speed * 0.5  # Patrol at half speed
	else:
		velocity = Vector2.ZERO
		_pick_patrol_target()


func _tick_chase(delta: float) -> void:
	# Lost target - return to patrol
	if target == null or not is_instance_valid(target):
		target = null
		_state = State.PATROL
		return

	var distance: float = global_position.distance_to(target.global_position)

	# Close enough to attack
	if distance <= attack_range and _attack_cooldown_timer <= 0.0:
		_state = State.ATTACK
		_attack_phase = 0
		_attack_timer = 0.0
		velocity = Vector2.ZERO
		return

	# Navigate toward player
	if nav_agent:
		nav_agent.target_position = target.global_position
		if not nav_agent.is_navigation_finished():
			var next_pos: Vector2 = nav_agent.get_next_path_position()
			var direction: Vector2 = (next_pos - global_position).normalized()
			velocity = direction * move_speed
		else:
			velocity = Vector2.ZERO
	else:
		# Fallback: direct movement
		var direction: Vector2 = (target.global_position - global_position).normalized()
		velocity = direction * move_speed


func _tick_attack(delta: float) -> void:
	_attack_timer += delta

	match _attack_phase:
		0:
			# Start telegraph
			_attack_phase = 1
			if target and is_instance_valid(target):
				show_telegraph(target.global_position, telegraph_duration)

		1:
			# Waiting for telegraph to finish
			if _attack_timer >= telegraph_duration:
				_attack_phase = 2
				_attack_timer = 0.0

		2:
			# Strike - deal damage if target still in range
			if target and is_instance_valid(target):
				var distance: float = global_position.distance_to(target.global_position)
				if distance <= attack_range * 1.5:  # Slight grace range
					_deal_damage_to_target()

			# Reset cooldown and return to chase
			_attack_cooldown_timer = attack_cooldown
			_state = State.CHASE


func _deal_damage_to_target() -> void:
	if target == null or not is_instance_valid(target):
		return

	if target.has_method("receive_damage"):
		var event := DamageEvent.new()
		event.base_damage = attack_damage
		event.element = "earth"
		event.source = self
		event.knockback_force = 100.0
		event.knockback_direction = (target.global_position - global_position).normalized()
		target.receive_damage(event)


func _pick_patrol_target() -> void:
	_patrol_target = _room_center + Vector2(
		randf_range(-_room_extents.x, _room_extents.x),
		randf_range(-_room_extents.y, _room_extents.y)
	)
	_patrol_timer = _patrol_interval
