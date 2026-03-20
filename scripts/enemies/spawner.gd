extends Node
## Handles staggered enemy spawning at designated spawn points.
## For Phase 1, only spawns stone_grunt scenes.

signal all_enemies_spawned
signal enemy_spawned(enemy: Node)

var spawn_points: Array[Marker2D] = []
var spawn_delay: float = 0.5

var _spawn_timer: Timer
var _pending_spawns: int = 0
var _current_scene: PackedScene
var _current_parent: Node
var _spawn_index: int = 0


func _ready() -> void:
	_spawn_timer = Timer.new()
	_spawn_timer.one_shot = true
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(_spawn_timer)


func spawn_enemies(count: int, enemy_scene: PackedScene, parent: Node) -> void:
	if count <= 0:
		all_enemies_spawned.emit()
		return

	_current_scene = enemy_scene
	_current_parent = parent
	_pending_spawns = count
	_spawn_index = 0

	# Spawn the first enemy immediately, then stagger the rest
	_do_next_spawn()


func _do_next_spawn() -> void:
	if _pending_spawns <= 0:
		all_enemies_spawned.emit()
		return

	var position: Vector2 = _get_spawn_position()
	_spawn_single(_current_scene, position, _current_parent)
	_pending_spawns -= 1
	_spawn_index += 1

	if _pending_spawns > 0:
		_spawn_timer.start(spawn_delay)


func _on_spawn_timer_timeout() -> void:
	_do_next_spawn()


func _spawn_single(scene: PackedScene, position: Vector2, parent: Node) -> void:
	if scene == null:
		push_error("Spawner: Cannot spawn, scene is null.")
		return

	var instance: Node2D = scene.instantiate() as Node2D
	if instance == null:
		push_error("Spawner: Instantiated scene is not a Node2D.")
		return

	instance.position = position

	if instance.has_signal("died"):
		instance.died.connect(_on_enemy_died.bind(instance))

	parent.add_child(instance)
	enemy_spawned.emit(instance)


func _get_spawn_position() -> Vector2:
	if spawn_points.is_empty():
		# Fallback: random position in a circle around origin
		var angle: float = randf() * TAU
		var radius: float = randf_range(200.0, 500.0)
		return Vector2(cos(angle) * radius, sin(angle) * radius)

	var marker: Marker2D = spawn_points[_spawn_index % spawn_points.size()]
	return marker.global_position


func _on_enemy_died(_enemy: Node) -> void:
	# Hook for tracking kills, dropping loot, etc.
	pass
