extends Node2D

# Phase 1: 3-room combat loop

@onready var room_container: Node2D = $RoomContainer
@onready var player: CharacterBody2D = $Player
@onready var spawner: Node = $Spawner
@onready var room_manager: Node = $RoomManager
@onready var hud: CanvasLayer = $HUD
@onready var death_screen: CanvasLayer = $DeathScreen

var room_scenes: Array[PackedScene] = []
var current_room_index: int = 0
var room_enemy_counts: Array[int] = [2, 3, 4]  # Phase 1: 3 rooms with increasing enemies
var enemies_alive: int = 0
var total_enemies_killed: int = 0

var stone_grunt_scene: PackedScene = preload("res://scenes/enemies/stone_grunt.tscn")
var room_scene: PackedScene = preload("res://scenes/rooms/combat_rooms/room_medium_arena.tscn")

func _ready() -> void:
	_set_death_screen_visible(false)

	# Connect player signals
	var stats = player.get_node("PlayerStats")
	stats.hp_changed.connect(_on_player_hp_changed)
	stats.stamina_changed.connect(_on_player_stamina_changed)
	stats.player_died.connect(_on_player_died)

	# Connect death screen restart button
	var restart_btn = death_screen.find_child("RestartButton", true, false)
	if restart_btn:
		restart_btn.pressed.connect(_on_restart_pressed)

	# Start first room
	_load_room(0)

func _load_room(index: int) -> void:
	current_room_index = index

	# Clear old room
	for child in room_container.get_children():
		child.queue_free()

	# Wait a frame for cleanup
	await get_tree().process_frame

	# Instance new room
	var room = room_scene.instantiate()
	room_container.add_child(room)

	# Place player at spawn point
	var spawn_point = room.find_child("SpawnPoint", true, false)
	if spawn_point:
		player.global_position = spawn_point.global_position
	else:
		player.global_position = Vector2(384, 340)

	# Set camera limits based on room size (768x384 for the medium arena)
	var cam = player.get_node("Camera2D")
	if cam:
		cam.limit_left = 0
		cam.limit_top = 0
		cam.limit_right = 768
		cam.limit_bottom = 384

	# Update HUD
	hud.update_floor(index + 1, "")

	# Spawn enemies
	if index < room_enemy_counts.size():
		_spawn_enemies(room_enemy_counts[index], room)

func _spawn_enemies(count: int, room: Node2D) -> void:
	enemies_alive = count

	# Get spawn points from room
	var spawn_points: Array[Node] = []
	var sp_container = room.find_child("SpawnPoints", true, false)
	if sp_container:
		spawn_points = sp_container.get_children()

	for i in range(count):
		# Stagger spawns
		if i > 0:
			await get_tree().create_timer(0.5).timeout

		var enemy = stone_grunt_scene.instantiate()
		room_container.add_child(enemy)

		# Position at spawn point or random
		if i < spawn_points.size():
			enemy.global_position = spawn_points[i].global_position
		else:
			enemy.global_position = Vector2(
				randf_range(100, 660),
				randf_range(80, 300)
			)

		# Give enemy a reference to the player as target
		enemy.target = player

		# Connect death signal
		if enemy.has_signal("died"):
			enemy.died.connect(_on_enemy_died)

func _on_enemy_died(_enemy: Node) -> void:
	enemies_alive -= 1
	total_enemies_killed += 1

	if enemies_alive <= 0:
		# Room cleared
		await get_tree().create_timer(0.5).timeout
		_on_room_cleared()

func _on_room_cleared() -> void:
	current_room_index += 1

	if current_room_index >= room_enemy_counts.size():
		# Run complete!
		_show_victory()
	else:
		# Load next room with fade
		_fade_transition()

func _fade_transition() -> void:
	# Simple fade: create a ColorRect overlay
	var overlay = ColorRect.new()
	overlay.color = Color.BLACK
	overlay.color.a = 0.0
	overlay.anchors_preset = Control.PRESET_FULL_RECT
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var canvas = CanvasLayer.new()
	canvas.layer = 15
	canvas.add_child(overlay)
	add_child(canvas)

	# Fade to black
	var tween = create_tween()
	tween.tween_property(overlay, "color:a", 1.0, 0.3)
	await tween.finished

	# Load next room
	_load_room(current_room_index)

	# Fade from black
	tween = create_tween()
	tween.tween_property(overlay, "color:a", 0.0, 0.3)
	await tween.finished

	canvas.queue_free()

func _on_player_hp_changed(current: float, maximum: float) -> void:
	hud.update_hp(current, maximum)

func _on_player_stamina_changed(current: float, maximum: float) -> void:
	hud.update_stamina(current, maximum)

func _on_player_died() -> void:
	# Show death screen
	await get_tree().create_timer(1.0).timeout
	_show_death_screen()

func _set_death_screen_visible(is_visible: bool) -> void:
	var panel = death_screen.get_node_or_null("Panel")
	if panel:
		panel.visible = is_visible

func _show_death_screen() -> void:
	_set_death_screen_visible(true)
	get_tree().paused = true
	death_screen.process_mode = Node.PROCESS_MODE_ALWAYS

	var floor_label = death_screen.find_child("FloorLabel", true, false)
	if floor_label:
		floor_label.text = "Floor Reached: %d" % (current_room_index + 1)

	var kills_label = death_screen.find_child("KillsLabel", true, false)
	if kills_label:
		kills_label.text = "Enemies Killed: %d" % total_enemies_killed

func _show_victory() -> void:
	_set_death_screen_visible(true)
	get_tree().paused = true
	death_screen.process_mode = Node.PROCESS_MODE_ALWAYS

	var title = death_screen.find_child("Title", true, false)
	if title:
		title.text = "Run Complete!"

	var floor_label = death_screen.find_child("FloorLabel", true, false)
	if floor_label:
		floor_label.text = "Rooms Cleared: %d" % room_enemy_counts.size()

	var kills_label = death_screen.find_child("KillsLabel", true, false)
	if kills_label:
		kills_label.text = "Enemies Killed: %d" % total_enemies_killed

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
