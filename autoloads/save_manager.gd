extends Node

const SAVE_PATH: String = "user://save_data.json"

var data: Dictionary = {}


func _ready() -> void:
	load_game()


func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		create_new_save()
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("SaveManager: Failed to open save file: " + str(FileAccess.get_open_error()))
		create_new_save()
		return

	var json_string: String = file.get_as_text()
	file.close()

	var json := JSON.new()
	var parse_result: int = json.parse(json_string)
	if parse_result != OK:
		push_error("SaveManager: Failed to parse save data: " + json.get_error_message())
		create_new_save()
		return

	data = json.data
	if typeof(data) != TYPE_DICTIONARY:
		push_error("SaveManager: Save data is not a dictionary, creating new save.")
		create_new_save()


func save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SaveManager: Failed to open save file for writing: " + str(FileAccess.get_open_error()))
		return

	var json_string: String = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()


func create_new_save() -> void:
	data = {
		"version": 1,
		"echoes": 0,
		"unlocked_elements": ["FIRE", "WATER"],
		"discovered_combinations": [],
		"hub_structures": {},
		"npcs_unlocked": ["keeper"],
		"lore_tablets_found": [],
		"bestiary": {},
		"statistics": {
			"total_runs": 0,
			"highest_floor": 0,
			"total_enemies_killed": 0,
			"total_damage_dealt": 0,
			"total_damage_taken": 0,
			"total_elements_collected": 0,
			"total_combinations_performed": 0,
			"total_echoes_earned": 0,
			"fastest_run_ms": 0,
			"longest_run_ms": 0,
		},
		"modifiers_active": [],
		"tower_cleared": false,
		"tutorial_complete": false,
		"total_runs_started": 0,
		"run_history_visuals": [],
		"most_used_element": "",
		"least_used_element": "",
		"primordial_affinity": {
			"FIRE": 0,
			"WATER": 0,
			"AIR": 0,
			"EARTH": 0,
			"LIGHT": 0,
			"DARK": 0,
		},
		"lore_tablet_26_unlocked": false,
	}
	save_game()
