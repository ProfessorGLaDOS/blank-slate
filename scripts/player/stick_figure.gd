extends Node2D

var line_width: float = 2.0
var color: Color = Color.BLACK

var limb_positions: Dictionary = {}

# Breathing animation state
var _breath_time: float = 0.0


func _ready() -> void:
	limb_positions = get_idle_pose()


func _draw() -> void:
	var head_pos: Vector2 = limb_positions.get("head", Vector2(0, -24))
	var neck_pos: Vector2 = limb_positions.get("neck", Vector2(0, -18))
	var hip_pos: Vector2 = limb_positions.get("hip", Vector2(0, 0))
	var left_shoulder: Vector2 = limb_positions.get("left_shoulder", Vector2(-6, -16))
	var right_shoulder: Vector2 = limb_positions.get("right_shoulder", Vector2(6, -16))
	var left_hand: Vector2 = limb_positions.get("left_hand", Vector2(-10, -4))
	var right_hand: Vector2 = limb_positions.get("right_hand", Vector2(10, -4))
	var left_hip: Vector2 = limb_positions.get("left_hip", Vector2(-4, 0))
	var right_hip: Vector2 = limb_positions.get("right_hip", Vector2(4, 0))
	var left_foot: Vector2 = limb_positions.get("left_foot", Vector2(-6, 14))
	var right_foot: Vector2 = limb_positions.get("right_foot", Vector2(6, 14))

	# Head (circle)
	draw_circle(head_pos, 4.0, color)

	# Spine (neck to hip)
	draw_line(neck_pos, hip_pos, color, line_width)

	# Left arm (shoulder to hand)
	draw_line(left_shoulder, left_hand, color, line_width)

	# Right arm (shoulder to hand)
	draw_line(right_shoulder, right_hand, color, line_width)

	# Left leg (hip to foot)
	draw_line(left_hip, left_foot, color, line_width)

	# Right leg (hip to foot)
	draw_line(right_hip, right_foot, color, line_width)


func set_pose(pose: Dictionary) -> void:
	limb_positions = pose
	queue_redraw()


func animate_breathing(delta: float) -> void:
	_breath_time += delta
	var offset := sin(_breath_time * 2.0) * 0.5
	var pose := limb_positions.duplicate()
	pose["neck"] = pose.get("neck", Vector2(0, -18)) + Vector2(0, offset)
	pose["hip"] = pose.get("hip", Vector2(0, 0)) + Vector2(0, offset * 0.5)
	limb_positions = pose
	queue_redraw()


# --- Pose helpers ---

static func get_idle_pose() -> Dictionary:
	return {
		"head": Vector2(0, -24),
		"neck": Vector2(0, -18),
		"hip": Vector2(0, 0),
		"left_shoulder": Vector2(-6, -16),
		"right_shoulder": Vector2(6, -16),
		"left_hand": Vector2(-10, -4),
		"right_hand": Vector2(10, -4),
		"left_hip": Vector2(-4, 0),
		"right_hip": Vector2(4, 0),
		"left_foot": Vector2(-6, 14),
		"right_foot": Vector2(6, 14),
	}


static func get_run_pose_a() -> Dictionary:
	return {
		"head": Vector2(0, -24),
		"neck": Vector2(0, -18),
		"hip": Vector2(0, 0),
		"left_shoulder": Vector2(-6, -16),
		"right_shoulder": Vector2(6, -16),
		"left_hand": Vector2(-14, -10),
		"right_hand": Vector2(14, -2),
		"left_hip": Vector2(-4, 0),
		"right_hip": Vector2(4, 0),
		"left_foot": Vector2(-10, 12),
		"right_foot": Vector2(8, 16),
	}


static func get_run_pose_b() -> Dictionary:
	return {
		"head": Vector2(0, -24),
		"neck": Vector2(0, -18),
		"hip": Vector2(0, 0),
		"left_shoulder": Vector2(-6, -16),
		"right_shoulder": Vector2(6, -16),
		"left_hand": Vector2(14, -2),
		"right_hand": Vector2(-14, -10),
		"left_hip": Vector2(-4, 0),
		"right_hip": Vector2(4, 0),
		"left_foot": Vector2(8, 16),
		"right_foot": Vector2(-10, 12),
	}


static func get_dodge_pose() -> Dictionary:
	return {
		"head": Vector2(0, -20),
		"neck": Vector2(0, -14),
		"hip": Vector2(0, 2),
		"left_shoulder": Vector2(-6, -12),
		"right_shoulder": Vector2(6, -12),
		"left_hand": Vector2(-12, -2),
		"right_hand": Vector2(12, -2),
		"left_hip": Vector2(-6, 2),
		"right_hip": Vector2(6, 2),
		"left_foot": Vector2(-10, 14),
		"right_foot": Vector2(10, 14),
	}


static func get_light_attack_pose_1() -> Dictionary:
	return {
		"head": Vector2(0, -24),
		"neck": Vector2(0, -18),
		"hip": Vector2(0, 0),
		"left_shoulder": Vector2(-6, -16),
		"right_shoulder": Vector2(6, -16),
		"left_hand": Vector2(-8, -6),
		"right_hand": Vector2(18, -14),
		"left_hip": Vector2(-4, 0),
		"right_hip": Vector2(4, 0),
		"left_foot": Vector2(-6, 14),
		"right_foot": Vector2(6, 14),
	}


static func get_light_attack_pose_2() -> Dictionary:
	return {
		"head": Vector2(0, -24),
		"neck": Vector2(0, -18),
		"hip": Vector2(0, 0),
		"left_shoulder": Vector2(-6, -16),
		"right_shoulder": Vector2(6, -16),
		"left_hand": Vector2(18, -12),
		"right_hand": Vector2(-8, -6),
		"left_hip": Vector2(-4, 0),
		"right_hip": Vector2(4, 0),
		"left_foot": Vector2(-6, 14),
		"right_foot": Vector2(6, 14),
	}


static func get_light_attack_pose_3() -> Dictionary:
	return {
		"head": Vector2(0, -24),
		"neck": Vector2(0, -18),
		"hip": Vector2(0, 0),
		"left_shoulder": Vector2(-6, -16),
		"right_shoulder": Vector2(6, -16),
		"left_hand": Vector2(16, -16),
		"right_hand": Vector2(20, -10),
		"left_hip": Vector2(-4, 0),
		"right_hip": Vector2(4, 0),
		"left_foot": Vector2(-4, 14),
		"right_foot": Vector2(8, 14),
	}


static func get_heavy_attack_pose() -> Dictionary:
	return {
		"head": Vector2(0, -22),
		"neck": Vector2(0, -16),
		"hip": Vector2(0, 2),
		"left_shoulder": Vector2(-6, -14),
		"right_shoulder": Vector2(6, -14),
		"left_hand": Vector2(20, -6),
		"right_hand": Vector2(22, -4),
		"left_hip": Vector2(-6, 2),
		"right_hip": Vector2(6, 2),
		"left_foot": Vector2(-8, 16),
		"right_foot": Vector2(6, 14),
	}


static func get_hurt_pose() -> Dictionary:
	return {
		"head": Vector2(-2, -22),
		"neck": Vector2(0, -16),
		"hip": Vector2(2, 2),
		"left_shoulder": Vector2(-8, -14),
		"right_shoulder": Vector2(4, -14),
		"left_hand": Vector2(-14, -2),
		"right_hand": Vector2(8, -2),
		"left_hip": Vector2(-4, 2),
		"right_hip": Vector2(6, 2),
		"left_foot": Vector2(-8, 14),
		"right_foot": Vector2(10, 14),
	}


static func get_death_pose() -> Dictionary:
	return {
		"head": Vector2(-8, 8),
		"neck": Vector2(-4, 6),
		"hip": Vector2(4, 8),
		"left_shoulder": Vector2(-6, 4),
		"right_shoulder": Vector2(2, 4),
		"left_hand": Vector2(-14, 8),
		"right_hand": Vector2(12, 10),
		"left_hip": Vector2(2, 8),
		"right_hip": Vector2(8, 8),
		"left_foot": Vector2(-2, 18),
		"right_foot": Vector2(14, 16),
	}
