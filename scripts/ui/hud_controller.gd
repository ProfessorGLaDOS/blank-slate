extends CanvasLayer
## Manages the in-game HUD: HP, stamina, abilities, essence, floor info, and boss HP.

@onready var hp_bar: TextureProgressBar = %HPBar
@onready var stamina_bar: TextureProgressBar = %StaminaBar
@onready var ability_icon_1: TextureRect = %AbilityIcon1
@onready var ability_icon_2: TextureRect = %AbilityIcon2
@onready var ability_icon_3: TextureRect = %AbilityIcon3
@onready var ability_icon_4: TextureRect = %AbilityIcon4
@onready var essence_label: Label = %EssenceLabel
@onready var floor_label: Label = %FloorLabel
@onready var boss_hp_bar: TextureProgressBar = %BossHPBar
@onready var boss_name_label: Label = %BossNameLabel

var _hp_flash_tween: Tween = null
var _is_hp_flashing: bool = false

const COLOR_GREEN := Color(0.2, 0.85, 0.2)
const COLOR_YELLOW := Color(0.95, 0.85, 0.1)
const COLOR_RED := Color(0.9, 0.15, 0.15)


func _ready() -> void:
	# Hide boss HP bar by default.
	_set_boss_bar_visible(false)


func update_hp(current: float, max_val: float) -> void:
	if hp_bar == null:
		return

	hp_bar.max_value = max_val
	hp_bar.value = current

	var ratio: float = current / maxf(max_val, 0.001)

	# Update bar color based on HP percentage.
	if ratio > 0.5:
		hp_bar.tint_progress = COLOR_GREEN
		_stop_hp_flash()
	elif ratio > 0.25:
		hp_bar.tint_progress = COLOR_YELLOW
		_stop_hp_flash()
	elif ratio > 0.1:
		hp_bar.tint_progress = COLOR_RED
		_stop_hp_flash()
	else:
		hp_bar.tint_progress = COLOR_RED
		_start_hp_flash()


func update_stamina(current: float, max_val: float) -> void:
	if stamina_bar == null:
		return
	stamina_bar.max_value = max_val
	stamina_bar.value = current


func update_abilities(abilities: Array) -> void:
	var icons: Array[TextureRect] = [ability_icon_1, ability_icon_2, ability_icon_3, ability_icon_4]

	for i in range(icons.size()):
		var icon: TextureRect = icons[i]
		if icon == null:
			continue

		if i < abilities.size():
			var ability: Dictionary = abilities[i]
			icon.visible = true
			icon.texture = ability.get("icon", null)

			# Cooldown overlay: look for a child ColorRect named "CooldownOverlay".
			var overlay := icon.get_node_or_null("CooldownOverlay") as ColorRect
			if overlay:
				var cooldown_ratio: float = ability.get("cooldown_ratio", 0.0)
				overlay.visible = cooldown_ratio > 0.0
				overlay.size.y = icon.size.y * cooldown_ratio
				overlay.position.y = icon.size.y * (1.0 - cooldown_ratio)
		else:
			icon.visible = false


func update_essence(amount: int) -> void:
	if essence_label == null:
		return
	essence_label.text = str(amount)


func update_floor(number: int, zone_name: String) -> void:
	if floor_label == null:
		return
	floor_label.text = "Floor %d - %s" % [number, zone_name]


func show_boss_hp(boss_name: String, current_hp: float, max_hp: float) -> void:
	_set_boss_bar_visible(true)
	if boss_name_label:
		boss_name_label.text = boss_name
	if boss_hp_bar:
		boss_hp_bar.max_value = max_hp
		boss_hp_bar.value = current_hp


func hide_boss_hp() -> void:
	_set_boss_bar_visible(false)


func _set_boss_bar_visible(visible_state: bool) -> void:
	if boss_hp_bar:
		boss_hp_bar.visible = visible_state
	if boss_name_label:
		boss_name_label.visible = visible_state


func _start_hp_flash() -> void:
	if _is_hp_flashing:
		return
	_is_hp_flashing = true

	_hp_flash_tween = create_tween()
	_hp_flash_tween.set_loops()
	_hp_flash_tween.tween_property(hp_bar, "modulate:a", 0.3, 0.25)
	_hp_flash_tween.tween_property(hp_bar, "modulate:a", 1.0, 0.25)


func _stop_hp_flash() -> void:
	if not _is_hp_flashing:
		return
	_is_hp_flashing = false

	if _hp_flash_tween and _hp_flash_tween.is_valid():
		_hp_flash_tween.kill()
		_hp_flash_tween = null

	if hp_bar:
		hp_bar.modulate.a = 1.0
