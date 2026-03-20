extends Node
## Manages NPC unlock conditions and dialogue for the Bastion hub.

# NPC unlock requirements:
#   keeper          - always unlocked
#   alchemist       - player has discovered 5 element combos
#   cartographer    - player has reached floor 10
#   merchant_prince - player has spent 500 total essence
#   archivist       - player has collected 10 tablets
#   challenger      - player has completed 5 challenge rooms
#   wanderer        - player has cleared the tower

var npc_unlock_conditions: Dictionary = {
	"keeper": {"type": "always"},
	"alchemist": {"type": "stat_gte", "stat": "combos_discovered", "threshold": 5},
	"cartographer": {"type": "stat_gte", "stat": "highest_floor", "threshold": 10},
	"merchant_prince": {"type": "stat_gte", "stat": "total_essence_spent", "threshold": 500},
	"archivist": {"type": "stat_gte", "stat": "tablets_collected", "threshold": 10},
	"challenger": {"type": "stat_gte", "stat": "challenge_rooms_completed", "threshold": 5},
	"wanderer": {"type": "flag", "flag": "tower_cleared"},
}

var _dialogue_table: Dictionary = {
	"keeper": {
		"default": "Welcome back to the Bastion. The tower awaits, as always.",
		"first_visit": "Ah, a new face. Welcome to the Bastion -- your refuge between ascensions.",
	},
	"alchemist": {
		"default": "Elements are the key to everything. Bring me more, and I'll show you what they can become.",
		"first_visit": "So you've begun to see how the elements intertwine. Good. I can help you refine that knowledge.",
	},
	"cartographer": {
		"default": "Every floor has its secrets. I can help you prepare for what lies ahead.",
		"first_visit": "You've climbed further than most. Let me share what I know of the tower's layout.",
	},
	"merchant_prince": {
		"default": "Essence flows through all things. Spend wisely, and you'll grow stronger than you imagine.",
		"first_visit": "A generous spender, I see. I deal in rare wares -- perhaps we can do business.",
	},
	"archivist": {
		"default": "Each tablet holds a fragment of the tower's memory. Keep searching.",
		"first_visit": "A collector of forgotten truths. The tablets you've gathered tell a story worth hearing.",
	},
	"challenger": {
		"default": "Ready for another test? The challenge rooms grow fiercer the higher you climb.",
		"first_visit": "You seek trials beyond the ordinary. I respect that. Let me offer you something worthy.",
	},
	"wanderer": {
		"default": "The tower remembers those who conquer it. But there is always more to discover.",
		"first_visit": "You've done what few have managed. The tower is beaten, but never truly finished.",
	},
}


func check_unlocks(save_data: Dictionary) -> Array[String]:
	var unlocked: Array[String] = []

	for npc_id in npc_unlock_conditions:
		var condition: Dictionary = npc_unlock_conditions[npc_id]

		match condition["type"]:
			"always":
				unlocked.append(npc_id)
			"stat_gte":
				var stat_name: String = condition["stat"]
				var threshold: int = condition["threshold"]
				var current_value: int = save_data.get(stat_name, 0)
				if current_value >= threshold:
					unlocked.append(npc_id)
			"flag":
				var flag_name: String = condition["flag"]
				if save_data.get(flag_name, false) == true:
					unlocked.append(npc_id)

	return unlocked


func get_npc_dialogue(npc_id: String, context: String = "default") -> String:
	if not _dialogue_table.has(npc_id):
		return "..."

	var dialogues: Dictionary = _dialogue_table[npc_id]
	if dialogues.has(context):
		return dialogues[context]

	return dialogues.get("default", "...")
