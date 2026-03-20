extends CharacterBody2D

signal died

enum State { IDLE, MOVING, DODGING, ATTACKING, ABILITY, HURT, DEATH }

# --- Body category driven stats (Bipedal defaults) ---
var move_speed: float = 150.0
var dodge_speed: float = 350.0
var dodge_duration: float = 0.4
var dodge_iframes: float = 0.2
var dodge_cooldown: float = 0.5
var dodge_stamina_cost: float = 25.0

const SPRINT_MULTIPLIER: float = 1.5

# --- State ---
var facing_direction: Vector2 = Vector2.RIGHT
var current_state: State = State.IDLE
var dodge_direction: Vector2 = Vector2.ZERO
var is_invincible: bool = false

# --- Combo system ---
var combo_count: int = 0
var _combo_reset_timer: float = 0.0
const COMBO_TIMEOUT: float = 0.4
const LIGHT_ATTACK_DAMAGES: Array[int] = [8, 8, 12]

# --- Heavy attack constants ---
const HEAVY_ATTACK_DAMAGE: int = 20
const HEAVY_ATTACK_DURATION: float = 0.8
const HEAVY_ATTACK_AOE_RADIUS: float = 30.0
const HEAVY_ATTACK_KNOCKBACK: float = 60.0

# --- Attack state tracking ---
var _attack_timer: float = 0.0
var _attack_duration: float = 0.0

# --- Child node references ---
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hurtbox: Area2D = $Hurtbox
@onready var hitbox_pivot: Node2D = $HitboxPivot
@onready var attack_hitbox: Area2D = $HitboxPivot/AttackHitbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var invincibility_timer: Timer = $InvincibilityTimer
@onready var dodge_cooldown_timer: Timer = $DodgeCooldownTimer
@onready var stamina_regen_timer: Timer = $StaminaRegenTimer
@onready var player_stats: Node = $PlayerStats


func _ready() -> void:
	invincibility_timer.one_shot = true
	invincibility_timer.timeout.connect(_on_invincibility_timer_timeout)
	dodge_cooldown_timer.one_shot = true


func _physics_process(delta: float) -> void:
	if current_state == State.DEATH:
		return

	if current_state == State.HURT:
		velocity = velocity.move_toward(Vector2.ZERO, 300.0 * delta)
		move_and_slide()
		return

	# Update combo reset timer
	if combo_count > 0:
		_combo_reset_timer -= delta
		if _combo_reset_timer <= 0.0:
			combo_count = 0

	# Update attack timer
	if current_state == State.ATTACKING or current_state == State.ABILITY:
		_attack_timer -= delta
		if _attack_timer <= 0.0:
			current_state = State.IDLE

	match current_state:
		State.IDLE, State.MOVING:
			var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
			handle_movement(input_dir, delta)
			check_dodge_input()
			check_attack_input()
		State.DODGING:
			velocity = dodge_direction * dodge_speed
		State.ATTACKING, State.ABILITY:
			velocity = velocity.move_toward(Vector2.ZERO, 400.0 * delta)

	move_and_slide()


func handle_movement(input_dir: Vector2, _delta: float) -> void:
	if input_dir != Vector2.ZERO:
		facing_direction = input_dir.normalized()
		# Rotate hitbox pivot to face direction
		hitbox_pivot.rotation = facing_direction.angle()

	var speed := move_speed
	if Input.is_action_pressed("sprint") and player_stats.stamina > 0.0:
		speed *= SPRINT_MULTIPLIER
		player_stats.consume_stamina(10.0 * _delta)

	if input_dir.length() > 0.0:
		velocity = input_dir.normalized() * speed
		if current_state != State.MOVING:
			current_state = State.MOVING
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed * 8.0 * _delta)
		if current_state != State.IDLE:
			current_state = State.IDLE


func check_dodge_input() -> void:
	if InputBuffer.consume("dodge"):
		if dodge_cooldown_timer.is_stopped() and player_stats.stamina >= dodge_stamina_cost:
			start_dodge()


func start_dodge() -> void:
	current_state = State.DODGING
	player_stats.consume_stamina(dodge_stamina_cost)

	# Use current input direction or facing direction
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir.length() > 0.0:
		dodge_direction = input_dir.normalized()
	else:
		dodge_direction = facing_direction

	# Start invincibility frames
	is_invincible = true
	invincibility_timer.wait_time = dodge_iframes
	invincibility_timer.start()

	# Schedule end of dodge
	var dodge_timer := get_tree().create_timer(dodge_duration)
	dodge_timer.timeout.connect(_on_dodge_finished)

	# Start cooldown
	dodge_cooldown_timer.wait_time = dodge_cooldown
	dodge_cooldown_timer.start()


func _on_dodge_finished() -> void:
	if current_state == State.DODGING:
		current_state = State.IDLE


func _on_invincibility_timer_timeout() -> void:
	is_invincible = false


func check_attack_input() -> void:
	if InputBuffer.consume("attack_light"):
		start_light_attack()
	elif InputBuffer.consume("attack_heavy"):
		start_heavy_attack()


func start_light_attack() -> void:
	current_state = State.ATTACKING

	var damage_index := clampi(combo_count, 0, LIGHT_ATTACK_DAMAGES.size() - 1)
	var damage: int = LIGHT_ATTACK_DAMAGES[damage_index]

	combo_count += 1
	if combo_count >= LIGHT_ATTACK_DAMAGES.size():
		combo_count = 0
	_combo_reset_timer = COMBO_TIMEOUT

	# Set attack duration based on combo hit
	_attack_duration = 0.3
	_attack_timer = _attack_duration

	# Deal damage to overlapping enemies
	_deal_attack_damage(damage, 0.0, 0.0)


func start_heavy_attack() -> void:
	current_state = State.ATTACKING

	_attack_duration = HEAVY_ATTACK_DURATION
	_attack_timer = _attack_duration

	# Reset combo on heavy attack
	combo_count = 0

	# Deal damage with AoE and knockback
	_deal_attack_damage(HEAVY_ATTACK_DAMAGE, HEAVY_ATTACK_AOE_RADIUS, HEAVY_ATTACK_KNOCKBACK)


func _deal_attack_damage(damage: int, _aoe_radius: float, knockback: float) -> void:
	if not is_instance_valid(attack_hitbox):
		return
	for body in attack_hitbox.get_overlapping_bodies():
		if body.has_method("receive_damage"):
			var damage_event := {
				"amount": damage,
				"source": self,
				"knockback_force": knockback,
				"knockback_direction": facing_direction,
			}
			body.receive_damage(damage_event)


func receive_damage(event: Dictionary) -> void:
	if is_invincible:
		return
	if current_state == State.DEATH:
		return

	var amount: float = event.get("amount", 0.0)
	player_stats.take_damage(amount)

	if player_stats.hp <= 0.0:
		_enter_death()
		return

	current_state = State.HURT

	# Apply knockback
	var kb_dir: Vector2 = event.get("knockback_direction", Vector2.ZERO)
	var kb_force: float = event.get("knockback_force", 0.0)
	velocity = kb_dir.normalized() * kb_force

	# Brief invincibility during hurt
	is_invincible = true
	invincibility_timer.wait_time = 0.3
	invincibility_timer.start()

	# Recover from hurt after short delay
	var hurt_timer := get_tree().create_timer(0.25)
	hurt_timer.timeout.connect(_on_hurt_finished)


func _on_hurt_finished() -> void:
	if current_state == State.HURT:
		current_state = State.IDLE


func _enter_death() -> void:
	current_state = State.DEATH
	velocity = Vector2.ZERO
	is_invincible = true
	died.emit()


func apply_body_category(data: Dictionary) -> void:
	move_speed = data.get("move_speed", move_speed)
	dodge_speed = data.get("dodge_speed", dodge_speed)
	dodge_duration = data.get("dodge_duration", dodge_duration)
	dodge_iframes = data.get("dodge_iframes", dodge_iframes)
	dodge_cooldown = data.get("dodge_cooldown", dodge_cooldown)
	dodge_stamina_cost = data.get("dodge_stamina_cost", dodge_stamina_cost)
