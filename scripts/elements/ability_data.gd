class_name AbilityData
extends Resource

@export var id: String
@export var display_name: String
@export var description: String
@export var slot: int  # 1-4
@export var damage: float
@export var cooldown: float
@export var stamina_cost: float = 0.0
@export var range_pixels: float = 0.0
@export var aoe_radius: float = 0.0
@export var element: String
@export var status_effect: String = ""
@export var status_duration: float = 0.0
@export var knockback_force: float = 0.0
@export var projectile_scene: PackedScene = null
@export var projectile_speed: float = 0.0
@export var projectile_count: int = 1
@export var cast_time: float = 0.0
@export var animation_name: String = ""
@export var sfx: AudioStream = null
@export var vfx_scene: PackedScene = null
