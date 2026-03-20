extends Node2D
## Manages the Bastion hub area between runs.
## Handles structure building, NPC spawning, and hub state persistence.

var structures_built: Dictionary = {}

# Structure definitions: id -> {cost, scene_path, position}
var structure_data: Dictionary = {
	"armory": {"cost": 50, "scene_path": "res://scenes/hub/structures/armory.tscn", "position": Vector2(200, 0)},
	"stamina_forge": {"cost": 75, "scene_path": "res://scenes/hub/structures/stamina_forge.tscn", "position": Vector2(-200, 0)},
	"echo_well": {"cost": 100, "scene_path": "res://scenes/hub/structures/echo_well.tscn", "position": Vector2(0, 200)},
	"alchemy_lab": {"cost": 60, "scene_path": "res://scenes/hub/structures/alchemy_lab.tscn", "position": Vector2(0, -200)},
	"cartography_table": {"cost": 80, "scene_path": "res://scenes/hub/structures/cartography_table.tscn", "position": Vector2(300, 200)},
	"archive": {"cost": 120, "scene_path": "res://scenes/hub/structures/archive.tscn", "position": Vector2(-300, 200)},
	"challenge_gate": {"cost": 150, "scene_path": "res://scenes/hub/structures/challenge_gate.tscn", "position": Vector2(300, -200)},
}

@onready var npc_manager: Node = $NPCManager


func _ready() -> void:
	_load_hub_state()
	_spawn_structures()
	_spawn_npcs()


func _load_hub_state() -> void:
	if SaveManager.has_data("hub_structures"):
		structures_built = SaveManager.get_data("hub_structures")


func _spawn_structures() -> void:
	for structure_id in structures_built:
		if structures_built[structure_id] == true:
			_spawn_structure_visual(structure_id)


func build_structure(structure_id: String) -> bool:
	if not structure_data.has(structure_id):
		push_warning("HubManager: Unknown structure id '%s'" % structure_id)
		return false

	if structures_built.has(structure_id) and structures_built[structure_id] == true:
		push_warning("HubManager: Structure '%s' already built" % structure_id)
		return false

	var cost: int = structure_data[structure_id]["cost"]
	var current_echoes: int = SaveManager.get_data("echoes", 0)

	if current_echoes < cost:
		return false

	SaveManager.set_data("echoes", current_echoes - cost)
	structures_built[structure_id] = true
	SaveManager.set_data("hub_structures", structures_built)
	SaveManager.save()

	_spawn_structure_visual(structure_id)
	return true


func _spawn_structure_visual(structure_id: String) -> void:
	if not structure_data.has(structure_id):
		return
	var data: Dictionary = structure_data[structure_id]
	if ResourceLoader.exists(data["scene_path"]):
		var scene: PackedScene = load(data["scene_path"])
		var instance: Node2D = scene.instantiate()
		instance.position = data["position"]
		instance.name = structure_id
		add_child(instance)


func get_available_structures() -> Array:
	var available: Array = []
	var current_echoes: int = SaveManager.get_data("echoes", 0)

	for structure_id in structure_data:
		if structures_built.has(structure_id) and structures_built[structure_id] == true:
			continue
		if structure_data[structure_id]["cost"] <= current_echoes:
			available.append({
				"id": structure_id,
				"cost": structure_data[structure_id]["cost"],
			})

	return available


func _spawn_npcs() -> void:
	if not npc_manager:
		push_warning("HubManager: NPCManager node not found")
		return

	var save_data: Dictionary = SaveManager.get_all_data()
	var unlocked_npcs: Array[String] = npc_manager.check_unlocks(save_data)

	for npc_id in unlocked_npcs:
		var npc_scene_path: String = "res://scenes/hub/npcs/%s.tscn" % npc_id
		if ResourceLoader.exists(npc_scene_path):
			var scene: PackedScene = load(npc_scene_path)
			var npc_instance: Node2D = scene.instantiate()
			npc_instance.name = npc_id
			add_child(npc_instance)
