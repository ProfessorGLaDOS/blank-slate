class_name ElementData
extends Resource

@export var id: String
@export var display_name: String
@export var tier: int  # 0=base, 1, 2, 3
@export var ingredients: Array[String] = []
@export var color_primary: Color
@export var color_secondary: Color
@export var visual_tier_contribution: int = 1
@export var creature_form_override: String = ""
@export var body_category: String = ""
@export var abilities: Array[Resource] = []  # Array of AbilityData
@export var ultimate: Resource = null  # UltimateData
@export var primary_status: String = ""
@export var particle_scene: PackedScene = null
@export var base_element_weights: Dictionary = {}
