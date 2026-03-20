extends CharacterBody2D

signal died(enemy: CharacterBody2D)

# Stats
var max_hp: float = 30.0
var hp: float = 30.0
var move_speed: float = 80.0
var detection_radius: float = 150.0
var attack_damage: float = 10.0
var attack_cooldown: float = 1.5
var attack_range: float = 25.0
var telegraph_duration: float = 0.4

# State
var is_dead: bool = false
var target: Node2D = null
var _attack_cooldown_timer: float = 0.0

# Node references
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var health_bar: ProgressBar = $HealthBar
@onready var sprite: Node2D = $Sprite2D
@onready var detection_area: Area2D = $DetectionArea

# Preloaded scenes
var damage_number_scene: PackedScene = preload("res://scenes/ui/damage_number.tscn")


func _ready() -> void:
	hp = max_hp

	if health_bar:
		health_bar.max_value = max_hp
		health_bar.value = hp
		health_bar.visible = false

	if detection_area:
		detection_area.body_entered.connect(_on_detection_entered)
		detection_area.body_exited.connect(_on_detection_exited)

	# Configure detection area collision shape radius
	if detection_area and detection_area.get_child_count() > 0:
		var shape: CollisionShape2D = detection_area.get_child(0) as CollisionShape2D
		if shape and shape.shape is CircleShape2D:
			(shape.shape as CircleShape2D).radius = detection_radius


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Tick attack cooldown
	if _attack_cooldown_timer > 0.0:
		_attack_cooldown_timer -= delta

	# Behavior tree tick (overridden by subclasses)
	_tick_behavior(delta)

	move_and_slide()


## Override in subclasses to implement AI behavior.
func _tick_behavior(_delta: float) -> void:
	pass


func receive_damage(event: DamageEvent) -> void:
	if is_dead:
		return

	hp -= event.base_damage
	hp = maxf(hp, 0.0)

	# Show and update health bar
	if health_bar:
		health_bar.visible = true
		health_bar.value = hp

	# Flash white
	_flash_white()

	# Spawn damage number
	spawn_damage_number(event.base_damage, event.element, event.is_combo_reaction)

	# Apply knockback
	if event.knockback_force > 0.0 and event.knockback_direction != Vector2.ZERO:
		velocity += event.knockback_direction.normalized() * event.knockback_force

	# Hit stop effect (brief freeze)
	_trigger_hit_stop()

	# Check death
	if hp <= 0.0:
		die()


func die() -> void:
	if is_dead:
		return
	is_dead = true

	# Disable collision
	set_physics_process(false)
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)

	# Play death animation (flash and shrink)
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, 0.4)
	tween.tween_property(self, "scale", Vector2(0.5, 0.5), 0.4)

	died.emit(self)

	# Queue free after animation
	await tween.finished
	queue_free()


func _on_detection_entered(body: Node2D) -> void:
	if body.is_in_group("player") and target == null:
		target = body


func _on_detection_exited(body: Node2D) -> void:
	if body == target:
		target = null


func show_telegraph(telegraph_position: Vector2, duration: float) -> void:
	# Create a simple red circle indicator
	var indicator := Sprite2D.new()
	indicator.position = telegraph_position - global_position
	indicator.modulate = Color(1.0, 0.0, 0.0, 0.4)
	add_child(indicator)

	# Fade in then remove
	var tween: Tween = create_tween()
	tween.tween_property(indicator, "modulate:a", 0.7, duration * 0.5)
	tween.tween_property(indicator, "modulate:a", 0.0, duration * 0.5)
	tween.tween_callback(indicator.queue_free)


func spawn_damage_number(amount: float, element: String = "", is_combo: bool = false) -> void:
	if damage_number_scene == null:
		return

	var dmg_number: Node2D = damage_number_scene.instantiate()
	dmg_number.global_position = global_position + Vector2(0, -20)

	# Add to scene tree above the enemy
	get_tree().current_scene.add_child(dmg_number)

	# Setup must be called after adding to tree so @onready vars are available
	if dmg_number.has_method("setup"):
		dmg_number.setup(amount, element, is_combo)


func _flash_white() -> void:
	if sprite == null:
		return

	sprite.modulate = Color.WHITE
	var tween: Tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.0)
	tween.tween_property(sprite, "modulate", Color(10, 10, 10, 1), 0.05)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1), 0.1)


func _trigger_hit_stop() -> void:
	Engine.time_scale = 0.1
	await get_tree().create_timer(0.03, true, false, true).timeout
	Engine.time_scale = 1.0
