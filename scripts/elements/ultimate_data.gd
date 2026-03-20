class_name UltimateData
extends Resource

@export var id: String
@export var display_name: String
@export var description: String
@export var charge_type: String  # damage_dealt, damage_taken, combo_reactions, kill_streak, timed_buildup, hp_threshold, elemental_saturation
@export var charge_threshold: float
@export var activation_type: String  # instant, transformation, channel, summon, field, sacrifice
@export var duration: float = 0.0
@export var channel_time: float = 0.0
@export var hp_cost_percent: float = 0.0
@export var interruptible: bool = false
@export var element: String
@export var script_override: GDScript = null
@export var vfx_scene: PackedScene = null
@export var sfx_activation: AudioStream = null
@export var sfx_loop: AudioStream = null
