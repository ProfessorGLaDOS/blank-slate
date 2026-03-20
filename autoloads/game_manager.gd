extends Node

enum GameState {
	MAIN_MENU,
	HUB,
	TOWER_RUN,
	PAUSED,
	ROOM_TRANSITION,
	DEATH_SCREEN,
	VICTORY_SCREEN,
}

var state: GameState = GameState.MAIN_MENU
var current_scene: Node = null
var run_state: Dictionary = {}

var _previous_state: GameState = GameState.MAIN_MENU


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if state == GameState.PAUSED:
			_unpause()
		elif state == GameState.TOWER_RUN or state == GameState.HUB:
			_pause()


func change_scene(scene_path: String) -> void:
	if current_scene:
		current_scene.queue_free()
		current_scene = null

	var packed_scene: PackedScene = load(scene_path)
	if packed_scene == null:
		push_error("GameManager: Failed to load scene: " + scene_path)
		return

	current_scene = packed_scene.instantiate()
	get_tree().root.add_child(current_scene)


func start_run() -> void:
	run_state = {
		"floor": 1,
		"elements_collected": {},
		"enemies_killed": 0,
		"time_started": Time.get_ticks_msec(),
		"abilities_used": {},
		"damage_dealt": 0,
		"damage_taken": 0,
		"highest_floor_reached": 1,
	}
	state = GameState.TOWER_RUN


func end_run(cause: String) -> void:
	var run_snapshot: Dictionary = run_state.duplicate(true)
	run_snapshot["cause"] = cause
	run_snapshot["time_ended"] = Time.get_ticks_msec()
	run_snapshot["duration_ms"] = run_snapshot["time_ended"] - run_snapshot["time_started"]

	# Award echoes based on performance
	var echoes_earned: int = _calculate_echoes(run_snapshot)
	SaveManager.data["echoes"] += echoes_earned
	run_snapshot["echoes_earned"] = echoes_earned

	# Update statistics
	var stats: Dictionary = SaveManager.data["statistics"]
	stats["total_runs"] += 1
	stats["total_enemies_killed"] += run_snapshot["enemies_killed"]
	if run_snapshot["highest_floor_reached"] > stats["highest_floor"]:
		stats["highest_floor"] = run_snapshot["highest_floor_reached"]

	# Store visual snapshot for hub character averaging
	SaveManager.data["run_history_visuals"].append(run_snapshot)

	SaveManager.save_game()

	run_state = {}

	if cause == "death":
		state = GameState.DEATH_SCREEN
	elif cause == "victory":
		state = GameState.VICTORY_SCREEN
	else:
		state = GameState.HUB


func _calculate_echoes(snapshot: Dictionary) -> int:
	var echoes: int = 0
	echoes += snapshot.get("highest_floor_reached", 0) * 10
	echoes += snapshot.get("enemies_killed", 0) * 2
	if snapshot.get("cause", "") == "victory":
		echoes += 100
	return echoes


func _pause() -> void:
	_previous_state = state
	state = GameState.PAUSED
	get_tree().paused = true


func _unpause() -> void:
	state = _previous_state
	get_tree().paused = false
