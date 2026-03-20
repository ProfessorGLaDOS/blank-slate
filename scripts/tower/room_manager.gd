extends Node
## Manages room loading, transitions, and enemy tracking within a floor.

signal room_cleared
signal room_entered

var current_room: Node2D = null
var enemies_alive: int = 0
var doors_locked: bool = false

var _fade_overlay: ColorRect = null


func _ready() -> void:
	_create_fade_overlay()


func _create_fade_overlay() -> void:
	var canvas := CanvasLayer.new()
	canvas.layer = 100
	add_child(canvas)

	_fade_overlay = ColorRect.new()
	_fade_overlay.color = Color(0.0, 0.0, 0.0, 0.0)
	_fade_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(_fade_overlay)


func load_room(room_scene: PackedScene, player: CharacterBody2D) -> void:
	if room_scene == null:
		push_error("RoomManager: room_scene is null")
		return

	current_room = room_scene.instantiate() as Node2D
	if current_room == null:
		push_error("RoomManager: Failed to instantiate room scene")
		return

	add_child(current_room)

	# Place the player at the room's spawn point if one exists.
	var spawn_point := current_room.get_node_or_null("SpawnPoint") as Marker2D
	if spawn_point:
		player.global_position = spawn_point.global_position
	else:
		player.global_position = Vector2.ZERO

	room_entered.emit()


func unload_room() -> void:
	if current_room != null:
		current_room.queue_free()
		current_room = null
	enemies_alive = 0
	doors_locked = false


func transition_to_room(next_scene: PackedScene, player: CharacterBody2D) -> void:
	# Fade to black.
	var fade_out_tween := create_tween()
	fade_out_tween.tween_property(_fade_overlay, "color:a", 1.0, 0.3)
	await fade_out_tween.finished

	unload_room()
	load_room(next_scene, player)

	# Fade back in.
	var fade_in_tween := create_tween()
	fade_in_tween.tween_property(_fade_overlay, "color:a", 0.0, 0.3)
	await fade_in_tween.finished


func _on_enemy_died(_enemy: Node) -> void:
	enemies_alive -= 1
	if enemies_alive < 0:
		enemies_alive = 0

	if enemies_alive == 0:
		unlock_doors()
		room_cleared.emit()


func lock_doors() -> void:
	doors_locked = true
	if current_room == null:
		return
	var doors := current_room.get_tree().get_nodes_in_group("doors")
	for door: Node in doors:
		if door.has_method("lock"):
			door.lock()


func unlock_doors() -> void:
	doors_locked = false
	if current_room == null:
		return
	var doors := current_room.get_tree().get_nodes_in_group("doors")
	for door: Node in doors:
		if door.has_method("unlock"):
			door.unlock()
	# Show exit indicator if present.
	var exit_indicator := current_room.get_node_or_null("ExitIndicator")
	if exit_indicator:
		exit_indicator.visible = true


func register_enemies(count: int) -> void:
	enemies_alive = count
	if enemies_alive > 0:
		lock_doors()
