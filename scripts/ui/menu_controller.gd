extends CanvasLayer
## Manages pause, death, and victory overlay screens.

signal resume_pressed
signal abandon_run_pressed
signal quit_pressed
signal return_to_hub_pressed

@onready var pause_panel: PanelContainer = %PausePanel
@onready var death_panel: PanelContainer = %DeathPanel
@onready var victory_panel: PanelContainer = %VictoryPanel

# Pause menu buttons
@onready var resume_button: Button = %ResumeButton
@onready var settings_button: Button = %SettingsButton
@onready var abandon_button: Button = %AbandonButton
@onready var quit_button: Button = %QuitButton

# Death screen elements
@onready var death_title_label: Label = %DeathTitleLabel
@onready var death_floor_label: Label = %DeathFloorLabel
@onready var death_kills_label: Label = %DeathKillsLabel
@onready var death_echoes_label: Label = %DeathEchoesLabel
@onready var death_return_button: Button = %DeathReturnButton

# Victory screen elements
@onready var victory_title_label: Label = %VictoryTitleLabel
@onready var victory_floor_label: Label = %VictoryFloorLabel
@onready var victory_kills_label: Label = %VictoryKillsLabel
@onready var victory_echoes_label: Label = %VictoryEchoesLabel
@onready var victory_combos_label: Label = %VictoryCombosLabel
@onready var victory_return_button: Button = %VictoryReturnButton


func _ready() -> void:
	_hide_all_panels()
	_connect_buttons()


func _connect_buttons() -> void:
	if resume_button:
		resume_button.pressed.connect(_on_resume_pressed)
	if settings_button:
		settings_button.pressed.connect(_on_settings_pressed)
	if abandon_button:
		abandon_button.pressed.connect(_on_abandon_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)
	if death_return_button:
		death_return_button.pressed.connect(_on_return_to_hub_pressed)
	if victory_return_button:
		victory_return_button.pressed.connect(_on_return_to_hub_pressed)


func _hide_all_panels() -> void:
	if pause_panel:
		pause_panel.visible = false
	if death_panel:
		death_panel.visible = false
	if victory_panel:
		victory_panel.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if pause_panel and pause_panel.visible:
			hide_pause()
		else:
			show_pause()
		get_viewport().set_input_as_handled()


# ---------------------------------------------------------------------------
# Pause Menu
# ---------------------------------------------------------------------------

func show_pause() -> void:
	_hide_all_panels()
	if pause_panel:
		pause_panel.visible = true
	get_tree().paused = true


func hide_pause() -> void:
	if pause_panel:
		pause_panel.visible = false
	get_tree().paused = false
	resume_pressed.emit()


# ---------------------------------------------------------------------------
# Death Screen
# ---------------------------------------------------------------------------

func show_death(stats: Dictionary) -> void:
	_hide_all_panels()
	get_tree().paused = true

	if death_panel:
		death_panel.visible = true
	if death_title_label:
		death_title_label.text = "You Died"
	if death_floor_label:
		death_floor_label.text = "Floor Reached: %d" % stats.get("floor_reached", 1)
	if death_kills_label:
		death_kills_label.text = "Enemies Killed: %d" % stats.get("enemies_killed", 0)
	if death_echoes_label:
		death_echoes_label.text = "Echoes Earned: %d" % stats.get("echoes_earned", 0)


# ---------------------------------------------------------------------------
# Victory Screen
# ---------------------------------------------------------------------------

func show_victory(stats: Dictionary) -> void:
	_hide_all_panels()
	get_tree().paused = true

	if victory_panel:
		victory_panel.visible = true
	if victory_title_label:
		victory_title_label.text = "Tower Cleared!"
	if victory_floor_label:
		victory_floor_label.text = "Floors Cleared: %d" % stats.get("floor_reached", 1)
	if victory_kills_label:
		victory_kills_label.text = "Enemies Killed: %d" % stats.get("enemies_killed", 0)
	if victory_echoes_label:
		victory_echoes_label.text = "Echoes Earned: %d" % stats.get("echoes_earned", 0)
	if victory_combos_label:
		victory_combos_label.text = "Combinations: %d" % stats.get("combinations_performed", 0)


# ---------------------------------------------------------------------------
# Button Callbacks
# ---------------------------------------------------------------------------

func _on_resume_pressed() -> void:
	hide_pause()


func _on_settings_pressed() -> void:
	# Placeholder for settings menu integration.
	pass


func _on_abandon_pressed() -> void:
	get_tree().paused = false
	abandon_run_pressed.emit()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	quit_pressed.emit()


func _on_return_to_hub_pressed() -> void:
	get_tree().paused = false
	_hide_all_panels()
	return_to_hub_pressed.emit()
