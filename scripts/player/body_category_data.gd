class_name BodyCategoryData
extends Resource

@export var id: String  # bipedal, quadruped, serpentine, arachnid, avian, amorphous, floating, arthropod, geometric, insectoid
@export var move_speed: float
@export var hitbox_radius: float
@export var hp_modifier: float
@export var dodge_speed: float = 350.0
@export var dodge_duration: float = 0.4
@export var dodge_iframes: float = 0.2
@export var dodge_cooldown: float = 0.5
@export var dodge_stamina_cost: float = 25.0
@export var passive_id: String
@export var passive_description: String
