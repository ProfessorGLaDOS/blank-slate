extends Node
## Generates the procedural layout of rooms for a single floor of the tower.

var room_templates: Array[PackedScene] = []

## Indices into room_templates for specific room types.
## Set these after populating room_templates.
var combat_room_index: int = 0
var boss_room_index: int = -1
var elite_room_index: int = -1
var shrine_room_index: int = -1
var altar_room_index: int = -1
var rest_room_index: int = -1
var merchant_room_index: int = -1


func generate_floor(floor_number: int, _zone_element: String, _biome_variant: String) -> Array:
	## Returns an ordered list of room scenes for this floor.
	## Phase 1 implementation: simple sequence of combat rooms with a possible boss.
	var rooms: Array = []
	var combat_count: int = randi_range(3, 6)

	# Determine special room type for this floor.
	var special_room_type: String = determine_special_room(floor_number)

	# Build the combat rooms.
	for i in range(combat_count):
		var scene: PackedScene = _get_combat_room(i, combat_count)
		if scene != null:
			rooms.append(scene)

	# Insert a special room in the middle if applicable.
	if special_room_type != "" and rooms.size() > 1:
		var special_scene: PackedScene = _get_special_room_scene(special_room_type)
		if special_scene != null:
			var insert_pos: int = rooms.size() / 2
			rooms.insert(insert_pos, special_scene)

	# 25% chance to add a branch path (extra combat room).
	if randf() < 0.25:
		var branch: PackedScene = _get_combat_room(0, combat_count)
		if branch != null:
			var insert_pos: int = randi_range(1, maxi(1, rooms.size() - 1))
			rooms.insert(insert_pos, branch)

	# Boss room on every 5th floor, otherwise 30% elite chance.
	var is_boss_floor: bool = (floor_number % 5 == 0)
	if is_boss_floor:
		var boss_scene: PackedScene = _get_boss_room()
		if boss_scene != null:
			rooms.append(boss_scene)
	elif randf() < 0.3:
		var elite_scene: PackedScene = _get_elite_room()
		if elite_scene != null:
			rooms.append(elite_scene)

	return rooms


func determine_special_room(floor_number: int) -> String:
	## Determines which special room (if any) appears on this floor.
	## Shrine every 2 floors, altar every 3 floors, rest every 5 floors (zone boundary).
	if floor_number % 5 == 0:
		return "rest"
	if floor_number % 3 == 0:
		return "altar"
	if floor_number % 2 == 0:
		return "shrine"
	return ""


func _get_combat_room(_room_index: int, _total_rooms: int) -> PackedScene:
	if room_templates.is_empty():
		return null
	if combat_room_index >= 0 and combat_room_index < room_templates.size():
		return room_templates[combat_room_index]
	return room_templates[0]


func _get_boss_room() -> PackedScene:
	if boss_room_index >= 0 and boss_room_index < room_templates.size():
		return room_templates[boss_room_index]
	return _get_combat_room(0, 1)


func _get_elite_room() -> PackedScene:
	if elite_room_index >= 0 and elite_room_index < room_templates.size():
		return room_templates[elite_room_index]
	return _get_combat_room(0, 1)


func _get_special_room_scene(room_type: String) -> PackedScene:
	match room_type:
		"shrine":
			if shrine_room_index >= 0 and shrine_room_index < room_templates.size():
				return room_templates[shrine_room_index]
		"altar":
			if altar_room_index >= 0 and altar_room_index < room_templates.size():
				return room_templates[altar_room_index]
		"rest":
			if rest_room_index >= 0 and rest_room_index < room_templates.size():
				return room_templates[rest_room_index]
		"merchant":
			if merchant_room_index >= 0 and merchant_room_index < room_templates.size():
				return room_templates[merchant_room_index]
	return null
