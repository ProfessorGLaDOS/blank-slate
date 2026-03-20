# BLANK SLATE — Technical Implementation Guide v1.0

**Companion document to BLANK_SLATE_GDD.md**
**Engine:** Godot 4.3+ (GDScript primary)
**Target:** Steam (Windows/Linux/Mac)

This document specifies HOW to build the game. The GDD specifies WHAT to build. Read both.

---

## 1. CORE ARCHITECTURE DECISIONS

### 1.1 2D Isometric via 2D Engine (Not 3D)

Blank Slate uses **Godot's 2D engine with isometric sprite art**, not 3D with orthographic projection. Reasons:
- Simpler collision and physics
- Sprite-based character system is easier to implement for 42+ creature forms
- Better performance budget for particle effects
- Claude Code generates more reliable 2D Godot code than 3D

**Isometric Projection:**
- Tile size: **64×32 pixels** (2:1 width:height ratio, standard isometric)
- Y-sorting enabled for depth ordering
- World coordinates are standard 2D (x, y) — the isometric transform is handled by the tilemap and camera
- Character sprites are drawn in isometric perspective (pre-rendered or drawn at the isometric angle)

### 1.2 Coordinate System

```
Screen space:        World space (internal):
    /\                 +Y
   /  \                 |
  /    \                |
 /      \        -X ----+---- +X
 \      /                |
  \    /                -Y
   \  /
    \/

Isometric tile mapping:
  screen_x = (world_x - world_y) * tile_width / 2
  screen_y = (world_x + world_y) * tile_height / 2
```

Godot's built-in `TileMap` node handles this transform when configured with `TileMap.tile_shape = TILE_SHAPE_ISOMETRIC`. Use this rather than manual coordinate conversion.

### 1.3 Resolution and Camera

- **Base resolution:** 1920×1080 (16:9)
- **Render resolution:** 640×360 (pixel art scaled 3x) OR 960×540 (scaled 2x). Decision: **960×540 scaled 2x** — gives more visual fidelity for creature forms while keeping the pixel art feel.
- **Stretch mode:** `canvas_items` (scales the 2D canvas)
- **Stretch aspect:** `keep` (black bars rather than distortion)
- **Camera:** `Camera2D` node attached to the player. Smoothing enabled, `position_smoothing_speed = 8.0`. Camera is confined to room bounds (set `limit_left`, `limit_right`, `limit_top`, `limit_bottom` per room).

---

## 2. PLAYER CHARACTER — NODE HIERARCHY

```
Player (CharacterBody2D)
├── CollisionShape2D                    # Hitbox — size varies by body category (see §2B)
├── HurtboxArea (Area2D)                # Damage reception
│   └── CollisionShape2D                # Slightly larger than hitbox
├── HitboxPivot (Node2D)               # Rotates to face attack direction
│   └── AttackHitbox (Area2D)           # Active only during attack frames
│       └── CollisionShape2D            # Shape varies per attack (rect for slash, circle for slam)
├── SpriteStack (Node2D)               # Y-sorted sprite layers
│   ├── BodySprite (AnimatedSprite2D)   # Base body (stick figure or creature form)
│   ├── ElementOverlay (AnimatedSprite2D) # Element-specific visual effects on body
│   └── EffectsLayer (AnimatedSprite2D) # Aura, glow, particle anchor
├── ParticleAnchor (Node2D)
│   ├── ElementParticles (GPUParticles2D) # Element trail particles
│   └── StatusParticles (GPUParticles2D)  # Active status effect particles
├── ShadowSprite (Sprite2D)             # Elliptical shadow below character
├── AnimationPlayer                      # Controls all animation state
├── AnimationTree                        # State machine for animation blending
│   └── AnimationNodeStateMachine        # States: idle, run, dodge, attack_light, attack_heavy, hurt, death, ability_1-4, ultimate
├── StateChart (Node)                    # Finite state machine for player states
├── AbilityCooldownTimers (Node)
│   ├── Ability1Timer (Timer)
│   ├── Ability2Timer (Timer)
│   ├── Ability3Timer (Timer)
│   └── Ability4Timer (Timer)
├── DodgeCooldownTimer (Timer)
├── StaminaRegenTimer (Timer)            # Delay before stamina regen starts
├── InvincibilityTimer (Timer)           # i-frame duration during dodge
└── AudioStreamPlayer2D                  # Footstep and action sounds
```

### 2.1 Collision Layers

| Layer | Bit | Contents |
|-------|-----|----------|
| 1 | `player_body` | Player's CharacterBody2D (physics movement) |
| 2 | `enemy_body` | Enemy CharacterBody2D |
| 3 | `player_hurtbox` | Player's damage reception area |
| 4 | `enemy_hurtbox` | Enemy damage reception area |
| 5 | `player_hitbox` | Player's attack areas |
| 6 | `enemy_hitbox` | Enemy attack areas |
| 7 | `walls` | Room walls, indestructible terrain |
| 8 | `destructible` | Destructible terrain objects |
| 9 | `hazards` | Environmental hazards (lava, spikes, etc.) |
| 10 | `projectiles_player` | Player projectiles |
| 11 | `projectiles_enemy` | Enemy projectiles |
| 12 | `pickups` | Essence, element shards, items |
| 13 | `interactables` | Doors, shrines, altars, merchants |
| 14 | `navigation` | Navigation mesh obstacles |

**Collision rules:**
- `player_body` collides with: `walls`, `destructible`, `enemy_body`
- `player_hurtbox` is scanned by: `enemy_hitbox`, `projectiles_enemy`, `hazards`
- `player_hitbox` scans for: `enemy_hurtbox`, `destructible`
- `projectiles_player` collides with: `enemy_hurtbox`, `walls`, `destructible`
- `projectiles_enemy` collides with: `player_hurtbox`, `walls`

### 2.2 Player State Machine

```
                    ┌──────────┐
                    │   IDLE   │◄──────────────────────────┐
                    └─────┬────┘                           │
                          │ movement input                  │
                    ┌─────▼────┐                           │
              ┌────►│  MOVING  │◄──────┐                   │
              │     └─────┬────┘       │                   │
              │           │            │                   │
    dodge input│    attack input    no input            animation
              │           │            │               complete
        ┌─────▼────┐ ┌───▼──────┐  ┌──┴──┐          ┌────┴────┐
        │ DODGING  │ │ATTACKING │  │IDLE │          │  HURT   │
        └─────┬────┘ └───┬──────┘  └─────┘          └────┬────┘
              │           │                               │
              │     ┌─────▼──────┐                  ┌────▼────┐
              │     │ ABILITY    │                   │  DEATH  │
              │     └─────┬──────┘                   └─────────┘
              │           │
              └───────────┘
                 all → IDLE on complete
```

**State priority** (higher overrides lower):
1. DEATH (cannot be interrupted)
2. HURT (stagger, 0.3s, cannot act)
3. DODGING (i-frames active, cannot be interrupted)
4. ABILITY (can be interrupted by HURT if not in i-frames)
5. ATTACKING (can be interrupted by DODGE or HURT)
6. MOVING (can be interrupted by anything)
7. IDLE (default)

### 2.3 Movement Implementation

Movement stats are driven by the player's current **body category** (see GDD §2.3.6). Body category changes when creature form changes.

```gdscript
# body_category_data.gd
class_name BodyCategoryData
extends Resource

@export var id: String                     # "bipedal", "quadruped", etc.
@export var move_speed: float              # pixels per second
@export var hitbox_radius: float           # collision circle radius
@export var hp_modifier: float             # multiplier (1.0 = no change, 1.25 = +25%)
@export var dodge_speed: float = 350.0
@export var dodge_duration: float = 0.4
@export var dodge_iframes: float = 0.2
@export var dodge_cooldown: float = 0.5
@export var dodge_stamina_cost: float = 25.0
@export var passive_id: String             # "trample", "hover", "absorption", etc.
@export var passive_description: String

# Populated from GDD §2.3.6:
# bipedal:    speed=150, hitbox=10, hp=1.0,  iframes=0.2, cooldown=0.5, passive=adaptable
# quadruped:  speed=140, hitbox=14, hp=1.25, iframes=0.15, cooldown=0.7, passive=trample
# serpentine: speed=155, hitbox=ellipse(8x16), hp=1.0, iframes=0.25, cooldown=0.4, passive=constrict
# arachnid:  speed=170, hitbox=10, hp=0.9,  iframes=0.2, cooldown=0.35, passive=web_sense
# avian:     speed=165, hitbox=8,  hp=0.85, iframes=0.25, cooldown=0.4, passive=airborne
# amorphous: speed=130, hitbox=14, hp=1.2,  iframes=0.3, cooldown=0.6, passive=absorption
# floating:  speed=145, hitbox=8,  hp=0.95, iframes=0.3, cooldown=0.5, passive=hover
# arthropod: speed=120, hitbox=12, hp=1.4,  iframes=0.35, cooldown=0.8, passive=endurance
# geometric: speed=140, hitbox=10, hp=1.1,  iframes=0.2, cooldown=0.5, passive=construct
# insectoid: speed=160, hitbox=7,  hp=0.8,  iframes=0.2, cooldown=0.3, passive=flutter
```

```gdscript
# player_controller.gd
extends CharacterBody2D

const SPRINT_MULTIPLIER := 1.5

# These are set by body category, not hardcoded
var move_speed: float = 150.0
var dodge_speed: float = 350.0
var dodge_duration: float = 0.4
var dodge_iframes: float = 0.2
var dodge_cooldown: float = 0.5
var dodge_stamina_cost: float = 25.0

var facing_direction := Vector2.RIGHT
var current_body_category: BodyCategoryData = null

func apply_body_category(data: BodyCategoryData) -> void:
    current_body_category = data
    move_speed = data.move_speed
    dodge_speed = data.dodge_speed
    dodge_duration = data.dodge_duration
    dodge_iframes = data.dodge_iframes
    dodge_cooldown = data.dodge_cooldown
    dodge_stamina_cost = data.dodge_stamina_cost
    
    # Resize hitbox
    var shape = $CollisionShape2D.shape as CircleShape2D
    shape.radius = data.hitbox_radius
    $HurtboxArea/CollisionShape2D.shape.radius = data.hitbox_radius + 2.0
    
    # Apply HP modifier
    stats.apply_hp_modifier(data.hp_modifier)
    
    # Activate passive
    passive_system.activate(data.passive_id)

func _physics_process(delta: float) -> void:
    if current_state == State.DEATH or current_state == State.HURT:
        return
    
    var input_dir := Vector2(
        Input.get_axis("move_left", "move_right"),
        Input.get_axis("move_up", "move_down")
    ).normalized()
    
    if input_dir != Vector2.ZERO:
        facing_direction = input_dir
    
    match current_state:
        State.IDLE, State.MOVING:
            handle_movement(input_dir, delta)
            check_attack_input()
            check_dodge_input()
            check_ability_input()
        State.DODGING:
            velocity = dodge_direction * dodge_speed
        State.ATTACKING, State.ABILITY:
            velocity = velocity.move_toward(Vector2.ZERO, 400.0 * delta)
    
    move_and_slide()

func handle_movement(input_dir: Vector2, delta: float) -> void:
    var speed := move_speed
    if Input.is_action_pressed("sprint") and stats.stamina > 0:
        speed *= SPRINT_MULTIPLIER
        stats.consume_stamina(10.0 * delta)
    
    if input_dir != Vector2.ZERO:
        velocity = input_dir * speed
        current_state = State.MOVING
    else:
        velocity = velocity.move_toward(Vector2.ZERO, 600.0 * delta)
        if velocity.length() < 5.0:
            current_state = State.IDLE
```

**HP modifier application:**
```gdscript
# player_stats.gd

func apply_hp_modifier(modifier: float) -> void:
    var hp_percent := hp / max_hp  # Preserve current HP percentage
    var base_max_hp := 100.0 + meta_hp_bonus  # Base + armory upgrades
    max_hp = base_max_hp * modifier
    hp = max_hp * hp_percent  # Proportional adjustment
```

**Important:** Movement is in screen-space 2D coordinates, NOT isometric-adjusted. The player presses "up" and the character moves up on screen (which is diagonally up-left in world space on an isometric grid). This is the standard for isometric action games (Hades, Diablo). Do NOT convert input to isometric axes.

### 2.4 Input Buffering

Real-time action games need input buffering to feel responsive. Buffer window: **0.15 seconds** (150ms).

```gdscript
# input_buffer.gd (Autoload or component)

var buffer: Dictionary = {}  # action_name -> timestamp
const BUFFER_WINDOW := 0.15

func _input(event: InputEvent) -> void:
    for action in ["attack_light", "attack_heavy", "dodge", "ability_1", 
                    "ability_2", "ability_3", "ability_4", "ultimate"]:
        if event.is_action_pressed(action):
            buffer[action] = Time.get_ticks_msec() / 1000.0

func consume(action: String) -> bool:
    if action in buffer:
        var age = Time.get_ticks_msec() / 1000.0 - buffer[action]
        if age <= BUFFER_WINDOW:
            buffer.erase(action)
            return true
    return false

func clear_all() -> void:
    buffer.clear()
```

Use `InputBuffer.consume("dodge")` instead of `Input.is_action_just_pressed("dodge")` in the state machine. This means if a player presses dodge 100ms before their attack animation ends, the dodge fires on the first available frame.

### 2.5 Hit Stop (Juice)

On successful hit: freeze both the attacker and target for **0.05 seconds** (3 frames at 60fps). This is the single most important "game feel" feature.

```gdscript
# hit_stop.gd (Autoload)

func trigger(duration: float = 0.05) -> void:
    Engine.time_scale = 0.0
    await get_tree().create_timer(duration, true, false, true).timeout
    Engine.time_scale = 1.0
```

Call `HitStop.trigger()` on every melee hit. For ranged hits, use `0.03` seconds. For combo reactions, use `0.1` seconds. For boss phase transitions, use `0.3` seconds.

---

## 3. ENEMY — NODE HIERARCHY

```
Enemy (CharacterBody2D)
├── CollisionShape2D                    # Physics body
├── HurtboxArea (Area2D)
│   └── CollisionShape2D
├── HitboxPivot (Node2D)
│   └── AttackHitbox (Area2D)
│       └── CollisionShape2D
├── SpriteStack (Node2D)
│   ├── BodySprite (AnimatedSprite2D)
│   └── StatusIndicator (Sprite2D)      # Shows current status effect icon above head
├── ShadowSprite (Sprite2D)
├── AnimationPlayer
├── NavigationAgent2D                    # Pathfinding
├── DetectionArea (Area2D)              # Aggro range
│   └── CollisionShape2D               # Circle, radius varies per enemy type
├── HealthBar (TextureProgressBar)       # Small bar above enemy, hidden until damaged
├── BehaviorTreeRoot (Node)             # AI root node
└── AudioStreamPlayer2D
```

### 3.1 Behavior Tree Implementation

Use a simple, custom behavior tree rather than a plugin. Three node types:

```gdscript
# bt_node.gd — Base class
class_name BTNode
extends Node

enum Status { SUCCESS, FAILURE, RUNNING }

func tick(actor: CharacterBody2D, delta: float) -> Status:
    return Status.FAILURE

# bt_selector.gd — Tries children in order, returns first SUCCESS
class_name BTSelector
extends BTNode

func tick(actor, delta) -> Status:
    for child in get_children():
        var result = child.tick(actor, delta)
        if result != Status.FAILURE:
            return result
    return Status.FAILURE

# bt_sequence.gd — Runs children in order, fails on first FAILURE
class_name BTSequence
extends BTNode

func tick(actor, delta) -> Status:
    for child in get_children():
        var result = child.tick(actor, delta)
        if result != Status.SUCCESS:
            return result
    return Status.SUCCESS
```

**Fodder enemy behavior tree:**
```
Selector
├── Sequence [flee if low HP]
│   ├── Condition: HP < 20%
│   └── Action: FleeFromPlayer
├── Sequence [attack if in range]
│   ├── Condition: PlayerInAttackRange
│   ├── Condition: AttackCooldownReady
│   └── Action: AttackPlayer
├── Sequence [chase if detected]
│   ├── Condition: PlayerDetected
│   └── Action: ChasePlayer
└── Action: Patrol
```

**Bruiser enemy behavior tree:**
```
Selector
├── Sequence [heavy attack if close]
│   ├── Condition: PlayerInMeleeRange
│   ├── Condition: HeavyAttackReady
│   └── Action: HeavyAttack (0.8s telegraph)
├── Sequence [charge if medium range]
│   ├── Condition: PlayerInChargeRange
│   ├── Condition: ChargeCooldownReady
│   └── Action: ChargeAttack
├── Sequence [chase]
│   ├── Condition: PlayerDetected
│   └── Action: ChasePlayer (slow speed)
└── Action: Patrol
```

### 3.2 Enemy Spawning

Enemies are placed in rooms via **spawn points** — `Marker2D` nodes in the room scene. Each spawn point has metadata:

```gdscript
# Room spawn point metadata (set in editor or via script)
@export var enemy_category: String = "fodder"  # fodder, bruiser, ranged, mobile, support
@export var spawn_delay: float = 0.0           # Seconds after room activation before spawn
@export var is_elite_candidate: bool = false    # Can this spawn be upgraded to elite
```

The `spawner.gd` system reads the room's spawn points, selects enemies from the current zone's element roster matching the requested category, and instances them.

---

## 4. ROOM AND FLOOR GENERATION

### 4.1 Room Structure

Each room is a **separate scene** (`.tscn`). Rooms are NOT procedurally generated internally — they are **hand-designed room templates** that are procedurally **selected and connected**.

```
Room (Node2D)
├── TileMap                             # Floor and wall tiles (isometric)
│   ├── Layer 0: Floor                  # Ground tiles
│   ├── Layer 1: Walls                  # Wall tiles (auto-configured collision)
│   └── Layer 2: Decorations            # Props, non-colliding visual elements
├── NavigationRegion2D                  # Baked navmesh for enemy pathfinding
├── SpawnPoints (Node2D)
│   ├── Spawn1 (Marker2D)
│   ├── Spawn2 (Marker2D)
│   └── ...
├── Hazards (Node2D)                    # Pre-placed hazard areas
│   └── [HazardArea] (Area2D + visuals)
├── Destructibles (Node2D)
│   └── [Destructible] (StaticBody2D + health)
├── DoorNorth (Area2D + Sprite2D)       # Door connection points
├── DoorSouth (Area2D + Sprite2D)
├── DoorEast (Area2D + Sprite2D)
├── DoorWest (Area2D + Sprite2D)
├── PlayerSpawnPoint (Marker2D)         # Where player enters
└── RoomLogic (Node)                    # Script handling room state
    └── room_logic.gd                   # Tracks enemies alive, door lock/unlock
```

### 4.2 Room Templates

Create room templates per biome variant. For Phase 1, create **6 generic combat room templates** that work for any element:

| Template | Size | Layout | Notes |
|----------|------|--------|-------|
| `room_small_open` | 8×8 tiles | Open arena, 2 pillars | 2–3 spawn points |
| `room_small_corridors` | 8×10 tiles | L-shaped with cover walls | 3 spawn points, flanking opportunities |
| `room_medium_arena` | 12×12 tiles | Open with central pillar cluster | 4–5 spawn points |
| `room_medium_hazard` | 12×10 tiles | Open with 2 hazard zones (element-agnostic) | 3–4 spawn points + hazard placements |
| `room_large_open` | 16×16 tiles | Large arena, scattered pillars and destructibles | 5–6 spawn points |
| `room_large_complex` | 16×12 tiles | Multi-section with chokepoints | 4–5 spawn points, supports ambush spawns |

**Biome-specific rooms** are created in Phase 4 by duplicating generic templates and reskinning the tileset + adding biome-specific hazards. The room structure and spawn point layout remains the same.

### 4.3 Floor Generation Algorithm

Floors use a **template-based linear sequence with optional branches**. NOT a maze. NOT BSP.

```gdscript
# floor_generator.gd

func generate_floor(floor_number: int, zone_element: String, biome_variant: String) -> FloorData:
    var floor_data := FloorData.new()
    var room_count := randi_range(3, 6)  # Combat rooms
    
    # Always start with entry room
    floor_data.rooms.append(load_room("entry", zone_element, biome_variant))
    
    # Generate linear sequence of combat rooms
    var available_templates := get_templates_for_biome(biome_variant)
    for i in range(room_count):
        var template = available_templates.pick_random()
        floor_data.rooms.append(template)
    
    # Insert special room (if applicable for this floor)
    var special := determine_special_room(floor_number)
    if special != "":
        var insert_pos := randi_range(2, floor_data.rooms.size() - 1)
        floor_data.rooms.insert(insert_pos, load_room(special, zone_element, biome_variant))
    
    # Boss room on every 5th floor, elite chance on others
    if floor_number % 5 == 0:
        floor_data.rooms.append(load_boss_room(zone_element))
    elif randf() < 0.3:  # 30% chance for elite encounter
        mark_room_as_elite(floor_data.rooms.pick_random())
    
    # Always end with exit room
    floor_data.rooms.append(load_room("exit", zone_element, biome_variant))
    
    # Optional branch: 25% chance, adds a side path of 1-2 rooms leading to bonus loot
    if randf() < 0.25:
        var branch_point := randi_range(1, floor_data.rooms.size() - 3)
        var branch_room := available_templates.pick_random()
        floor_data.add_branch(branch_point, branch_room)
    
    return floor_data
```

**Room transitions:** When the player steps on a door trigger (`Area2D`), the game:
1. Fades to black (0.3s)
2. Unloads the current room scene
3. Loads the next room scene
4. Places the player at the corresponding entry point
5. Fades from black (0.3s)
6. If the room has enemies, locks the doors

This is simple scene swapping, NOT keeping all rooms in memory simultaneously.

### 4.4 Navigation Mesh

Each room template has a pre-baked `NavigationRegion2D`. Enemies use `NavigationAgent2D` for pathfinding.

**Bake settings:**
- `cell_size`: 8.0 (half a tile for precision around corners)
- `agent_radius`: 10.0 (matches enemy collision)
- Navigation mesh must be rebaked if destructible terrain is destroyed (call `NavigationServer2D.region_set_navigation_mesh()` after destruction)

---

## 5. COMBAT SYSTEM — TECHNICAL DETAILS

### 5.1 Damage Pipeline

Every damage instance flows through this pipeline:

```
Source (ability/attack/hazard)
    │
    ▼
DamageEvent {
    base_damage: float,
    element: String,          # "FIRE", "WATER", etc. or "" for physical
    source: Node,             # Who dealt it
    status_effect: String,    # Status to apply, or ""
    status_duration: float,
    knockback_force: float,
    knockback_direction: Vector2,
    is_combo_reaction: bool
}
    │
    ▼
Target.receive_damage(event: DamageEvent)
    │
    ├── Check invincibility (dodge i-frames) → discard if invincible
    ├── Apply resistance multiplier (§4.4 of GDD)
    ├── Apply status effect modifiers (Cursed = +20% damage taken)
    ├── Calculate final damage
    ├── Apply knockback
    ├── Apply status effect
    ├── Check for combo reactions (§4.5 of GDD)
    │   └── If combo triggers → create new DamageEvent for combo reaction
    ├── Emit signal "damage_taken(final_damage, element)"
    ├── Spawn floating damage number
    ├── Trigger hit stop
    ├── Flash sprite white for 0.1s (hit feedback)
    └── Check death (HP <= 0)
```

```gdscript
# damage_event.gd
class_name DamageEvent
extends RefCounted

var base_damage: float
var element: String = ""
var source: Node = null
var status_effect: String = ""
var status_duration: float = 0.0
var knockback_force: float = 0.0
var knockback_direction: Vector2 = Vector2.ZERO
var is_combo_reaction: bool = false
```

### 5.2 Hitbox Activation

Attack hitboxes are NOT always active. They activate on specific animation frames and deactivate after.

```gdscript
# In AnimationPlayer, call these methods at keyframed moments:

func activate_hitbox(hitbox_name: String, damage: float, element: String, 
                     shape_override: Shape2D = null) -> void:
    var hitbox = get_node("HitboxPivot/AttackHitbox")
    hitbox.monitoring = true
    hitbox.set_meta("damage", damage)
    hitbox.set_meta("element", element)
    if shape_override:
        hitbox.get_child(0).shape = shape_override

func deactivate_hitbox() -> void:
    var hitbox = get_node("HitboxPivot/AttackHitbox")
    hitbox.monitoring = false
    # Clear hit list so the same attack can't hit the same enemy twice
    _hit_targets_this_swing.clear()
```

**Critical rule:** Each attack swing can only hit a given target **once**. Track hit targets per swing in an array, reset when the hitbox deactivates.

### 5.3 Projectile System

```
Projectile (Area2D)
├── CollisionShape2D           # Hitbox
├── Sprite2D                   # Visual
├── GPUParticles2D             # Trail effect
├── VisibleOnScreenNotifier2D  # Auto-free when off screen
└── ProjectileLogic            # Script: speed, damage, element, homing, lifetime
```

```gdscript
# projectile.gd
extends Area2D

@export var speed: float = 300.0
@export var damage: float = 25.0
@export var element: String = "FIRE"
@export var lifetime: float = 3.0
@export var piercing: bool = false

var direction: Vector2 = Vector2.RIGHT

func _ready():
    body_entered.connect(_on_hit)
    area_entered.connect(_on_hit_area)
    get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta):
    position += direction * speed * delta

func _on_hit(body):
    if body.has_method("receive_damage"):
        var event = DamageEvent.new()
        event.base_damage = damage
        event.element = element
        event.source = owner
        event.knockback_direction = direction
        event.knockback_force = 50.0
        body.receive_damage(event)
    if not piercing:
        queue_free()
```

### 5.4 Status Effect System

```gdscript
# status_effect_manager.gd — Component attached to any entity that can have status effects

class_name StatusEffectManager
extends Node

var active_effects: Dictionary = {}  # effect_name -> StatusEffectInstance

func apply_effect(effect_name: String, duration: float, source_element: String) -> void:
    if effect_name in active_effects:
        # Check stacking rules per GDD §4.4
        match effect_name:
            "burning":
                active_effects[effect_name].stacks = mini(
                    active_effects[effect_name].stacks + 1, 10)
                active_effects[effect_name].remaining = duration  # refresh
            "frozen", "entangled", "cursed", "blessed":
                active_effects[effect_name].remaining = duration  # refresh only
            "poisoned":
                active_effects[effect_name].stacks = mini(
                    active_effects[effect_name].stacks + 1, 5)
            "shocked":
                pass  # Does not stack or refresh
    else:
        var instance = StatusEffectInstance.new()
        instance.effect_name = effect_name
        instance.remaining = duration
        instance.stacks = 1
        instance.source_element = source_element
        active_effects[effect_name] = instance
        emit_signal("effect_applied", effect_name)
    
    # Check for combo reactions
    _check_combo_reactions(effect_name, source_element)

func _check_combo_reactions(new_effect: String, source_element: String) -> void:
    # Combo reaction table from GDD §4.5
    var combos = {
        ["frozen", "FIRE"]: "shatter",
        ["burning", "WATER"]: "steam_burst",
        ["poisoned", "FIRE"]: "toxic_ignition",
        ["shocked", "WATER"]: "conduction",
        ["entangled", "AIR"]: "uproot",
        ["cursed", "LIGHT"]: "purge",
        ["blinded", "DARK"]: "terror"
    }
    
    for combo_key in combos:
        var required_status = combo_key[0]
        var trigger_element = combo_key[1]
        if required_status in active_effects and source_element == trigger_element:
            trigger_combo_reaction(combos[combo_key])
            break
```

### 5.5 Attack Telegraphing

Every enemy attack must show a visual telegraph before dealing damage.

```gdscript
# telegraph.gd — Reusable telegraph indicator

class_name AttackTelegraph
extends Node2D

@onready var indicator: Sprite2D = $Indicator  # Red translucent shape
@onready var timer: Timer = $Timer

func show_telegraph(shape: Shape2D, duration: float, color: Color = Color(1, 0, 0, 0.3)) -> void:
    # Draw the shape at the attack position
    indicator.modulate = color
    indicator.visible = true
    
    # Animate: fade from 0.1 to 0.5 alpha over duration
    var tween = create_tween()
    tween.tween_property(indicator, "modulate:a", 0.5, duration)
    
    timer.start(duration)
    await timer.timeout
    indicator.visible = false
    emit_signal("telegraph_complete")  # Enemy executes attack on this signal
```

---

## 6. ELEMENT AND ABILITY SYSTEM

### 6.1 Element Data Resource

```gdscript
# element_data.gd
class_name ElementData
extends Resource

@export var id: String                          # "FIRE", "STEAM", etc.
@export var display_name: String
@export var tier: int                           # 0=base, 1, 2, 3
@export var ingredients: Array[String] = []     # ["FIRE", "WATER"] for Steam
@export var color_primary: Color
@export var color_secondary: Color
@export var visual_tier_contribution: int = 1
@export var creature_form_override: String = "" # "ooze", "arachnid", etc. or "" for default
@export var body_category: String = ""          # Override body category or "" for auto
@export var abilities: Array[AbilityData] = []  # Exactly 4
@export var ultimate: UltimateData = null
@export var primary_status: String = ""         # "burning", "frozen", etc.
@export var particle_scene: PackedScene = null
@export var base_element_weights: Dictionary = {} # {"FIRE": 1.0} or {"FIRE": 0.6, "WATER": 0.6}
```

### 6.2 Ability Data Resource

```gdscript
# ability_data.gd
class_name AbilityData
extends Resource

@export var id: String
@export var display_name: String
@export var description: String
@export var slot: int                    # 1, 2, 3, or 4
@export var damage: float
@export var cooldown: float              # seconds
@export var stamina_cost: float = 0.0
@export var range_pixels: float = 0.0    # 0 = melee
@export var aoe_radius: float = 0.0      # 0 = single target
@export var element: String
@export var status_effect: String = ""
@export var status_duration: float = 0.0
@export var knockback_force: float = 0.0
@export var projectile_scene: PackedScene = null  # null = melee attack
@export var projectile_speed: float = 0.0
@export var projectile_count: int = 1
@export var cast_time: float = 0.0       # Wind-up before execution
@export var animation_name: String       # Animation to play
@export var sfx: AudioStream = null
@export var vfx_scene: PackedScene = null
```

### 6.3 Ultimate Data Resource

```gdscript
# ultimate_data.gd
class_name UltimateData
extends Resource

@export var id: String
@export var display_name: String
@export var description: String
@export var charge_type: String           # "damage_dealt", "damage_taken", "combo_reactions",
                                          # "kill_streak", "timed_buildup", "hp_threshold",
                                          # "elemental_saturation"
@export var charge_threshold: float       # Amount needed for full charge (varies by type)
@export var activation_type: String       # "instant", "transformation", "channel", "summon",
                                          # "field", "sacrifice"
@export var duration: float = 0.0         # 0 for instant
@export var channel_time: float = 0.0     # 0 for non-channel
@export var hp_cost_percent: float = 0.0  # For sacrifice types
@export var interruptible: bool = false   # Can be interrupted during channel
@export var element: String
@export var script_override: GDScript     # Custom logic for complex ultimates
@export var vfx_scene: PackedScene
@export var sfx_activation: AudioStream
@export var sfx_loop: AudioStream = null  # For transformations/fields
```

### 6.4 Complete Fire Ability Definitions

**These serve as the template for all other elements. Copy this pattern exactly.**

```gdscript
# res://resources/elements/fire.tres — Created in code or Godot editor

# Ability 1: Fireball
var fire_ability_1 := AbilityData.new()
fire_ability_1.id = "fire_fireball"
fire_ability_1.display_name = "Fireball"
fire_ability_1.description = "Hurl a ball of fire that ignites on impact."
fire_ability_1.slot = 1
fire_ability_1.damage = 25.0
fire_ability_1.cooldown = 1.5
fire_ability_1.range_pixels = 400.0
fire_ability_1.aoe_radius = 0.0           # Single target (explodes on contact)
fire_ability_1.element = "FIRE"
fire_ability_1.status_effect = "burning"
fire_ability_1.status_duration = 3.0
fire_ability_1.knockback_force = 30.0
fire_ability_1.projectile_speed = 350.0
fire_ability_1.projectile_count = 1
fire_ability_1.cast_time = 0.0
fire_ability_1.animation_name = "ability_1_cast"

# Ability 2: Flame Wave
var fire_ability_2 := AbilityData.new()
fire_ability_2.id = "fire_flame_wave"
fire_ability_2.display_name = "Flame Wave"
fire_ability_2.description = "Release a cone of fire that pushes enemies back."
fire_ability_2.slot = 2
fire_ability_2.damage = 15.0
fire_ability_2.cooldown = 3.0
fire_ability_2.range_pixels = 120.0       # Cone range
fire_ability_2.aoe_radius = 80.0          # Cone width at max range
fire_ability_2.element = "FIRE"
fire_ability_2.status_effect = ""
fire_ability_2.knockback_force = 120.0
fire_ability_2.cast_time = 0.1
fire_ability_2.animation_name = "ability_2_cast"

# Ability 3: Ember Dash
var fire_ability_3 := AbilityData.new()
fire_ability_3.id = "fire_ember_dash"
fire_ability_3.display_name = "Ember Dash"
fire_ability_3.description = "Dash forward leaving a trail of fire."
fire_ability_3.slot = 3
fire_ability_3.damage = 0.0               # Dash itself doesn't damage; trail does
fire_ability_3.cooldown = 2.0
fire_ability_3.range_pixels = 150.0       # Dash distance
fire_ability_3.element = "FIRE"
fire_ability_3.cast_time = 0.0
fire_ability_3.animation_name = "ability_3_dash"
# Note: Trail logic handled by script_override — spawns fire hazard zones along path
# Trail: 5 damage/s for 4 seconds, each trail segment is a small Area2D

# Ability 4: Inferno
var fire_ability_4 := AbilityData.new()
fire_ability_4.id = "fire_inferno"
fire_ability_4.display_name = "Inferno"
fire_ability_4.description = "Erupt in flames, devastating everything nearby."
fire_ability_4.slot = 4
fire_ability_4.damage = 60.0
fire_ability_4.cooldown = 15.0
fire_ability_4.aoe_radius = 120.0         # Large circle around player
fire_ability_4.element = "FIRE"
fire_ability_4.status_effect = "burning"
fire_ability_4.status_duration = 3.0
fire_ability_4.knockback_force = 80.0
fire_ability_4.cast_time = 0.3            # Brief windup
fire_ability_4.animation_name = "ability_4_cast"
# Note: Also destroys destructible terrain in radius
```

### 6.5 Complete Water Ability Definitions

```gdscript
# Ability 1: Tide Shot
var water_ability_1 := AbilityData.new()
water_ability_1.id = "water_tide_shot"
water_ability_1.display_name = "Tide Shot"
water_ability_1.description = "Fire a pressurized bolt of water."
water_ability_1.slot = 1
water_ability_1.damage = 20.0
water_ability_1.cooldown = 1.2
water_ability_1.range_pixels = 350.0
water_ability_1.element = "WATER"
water_ability_1.status_effect = ""         # No status on base shot
water_ability_1.knockback_force = 60.0     # Water has higher knockback than fire
water_ability_1.projectile_speed = 300.0
water_ability_1.projectile_count = 1
water_ability_1.cast_time = 0.0
water_ability_1.animation_name = "ability_1_cast"
# Note: Creates a small water puddle at impact point (persists 5s, enables Conduction)

# Ability 2: Riptide
var water_ability_2 := AbilityData.new()
water_ability_2.id = "water_riptide"
water_ability_2.display_name = "Riptide"
water_ability_2.description = "Pull enemies toward you with a water vortex."
water_ability_2.slot = 2
water_ability_2.damage = 12.0
water_ability_2.cooldown = 4.0
water_ability_2.range_pixels = 200.0
water_ability_2.aoe_radius = 100.0
water_ability_2.element = "WATER"
water_ability_2.knockback_force = -100.0   # NEGATIVE = pull toward player
water_ability_2.cast_time = 0.2
water_ability_2.animation_name = "ability_2_cast"

# Ability 3: Aqua Shift
var water_ability_3 := AbilityData.new()
water_ability_3.id = "water_aqua_shift"
water_ability_3.display_name = "Aqua Shift"
water_ability_3.description = "Dissolve into water and reform at target location."
water_ability_3.slot = 3
water_ability_3.damage = 0.0
water_ability_3.cooldown = 3.0
water_ability_3.range_pixels = 180.0       # Teleport distance
water_ability_3.element = "WATER"
water_ability_3.cast_time = 0.0
water_ability_3.animation_name = "ability_3_teleport"
# Note: Leaves water puddle at origin AND destination. Player has i-frames during teleport.

# Ability 4: Tsunami
var water_ability_4 := AbilityData.new()
water_ability_4.id = "water_tsunami"
water_ability_4.display_name = "Tsunami"
water_ability_4.description = "Summon a massive wave that crashes across the room."
water_ability_4.slot = 4
water_ability_4.damage = 50.0
water_ability_4.cooldown = 18.0
water_ability_4.range_pixels = 500.0       # Wave travels far
water_ability_4.aoe_radius = 60.0          # Wave width
water_ability_4.element = "WATER"
water_ability_4.status_effect = "frozen"   # Slows (not full freeze) at base
water_ability_4.status_duration = 2.0
water_ability_4.knockback_force = 150.0    # Massive knockback
water_ability_4.cast_time = 0.4
water_ability_4.animation_name = "ability_4_cast"
# Note: Wave is a moving Area2D that travels in facing direction, 60px wide
```

### 6.6 Complete Steam (Fire+Water) Ability Definitions

```gdscript
# Ability 1: Steam Blast
var steam_ability_1 := AbilityData.new()
steam_ability_1.id = "steam_blast"
steam_ability_1.display_name = "Steam Blast"
steam_ability_1.slot = 1
steam_ability_1.damage = 30.0
steam_ability_1.cooldown = 2.0
steam_ability_1.range_pixels = 130.0
steam_ability_1.aoe_radius = 70.0          # Cone
steam_ability_1.element = "STEAM"
steam_ability_1.status_effect = "blinded"
steam_ability_1.status_duration = 2.0
steam_ability_1.cast_time = 0.0
steam_ability_1.animation_name = "ability_1_cast"

# Ability 2: Pressure Bomb
var steam_ability_2 := AbilityData.new()
steam_ability_2.id = "steam_pressure_bomb"
steam_ability_2.display_name = "Pressure Bomb"
steam_ability_2.slot = 2
steam_ability_2.damage = 40.0
steam_ability_2.cooldown = 4.0
steam_ability_2.range_pixels = 250.0       # Thrown distance
steam_ability_2.aoe_radius = 80.0
steam_ability_2.element = "STEAM"
steam_ability_2.knockback_force = 100.0
steam_ability_2.cast_time = 0.0
steam_ability_2.animation_name = "ability_2_cast"
# Note: Placed bomb, detonates after 1.5s. Visible countdown indicator on ground.

# Ability 3: Vapor Step
var steam_ability_3 := AbilityData.new()
steam_ability_3.id = "steam_vapor_step"
steam_ability_3.display_name = "Vapor Step"
steam_ability_3.slot = 3
steam_ability_3.damage = 10.0              # Damage at origin (steam cloud)
steam_ability_3.cooldown = 2.5
steam_ability_3.range_pixels = 160.0
steam_ability_3.aoe_radius = 40.0          # Cloud at origin
steam_ability_3.element = "STEAM"
steam_ability_3.status_effect = "burning"
steam_ability_3.status_duration = 2.0
steam_ability_3.cast_time = 0.0
steam_ability_3.animation_name = "ability_3_teleport"
# Note: Teleport to target + damaging steam cloud at origin. i-frames during teleport.

# Ability 4: Boiler Burst
var steam_ability_4 := AbilityData.new()
steam_ability_4.id = "steam_boiler_burst"
steam_ability_4.display_name = "Boiler Burst"
steam_ability_4.slot = 4
steam_ability_4.damage = 80.0
steam_ability_4.cooldown = 20.0
steam_ability_4.aoe_radius = 150.0
steam_ability_4.element = "STEAM"
steam_ability_4.status_effect = "shocked"  # Stun (uses shocked as stand-in for stun)
steam_ability_4.status_duration = 1.5
steam_ability_4.knockback_force = 60.0
steam_ability_4.cast_time = 0.5
steam_ability_4.animation_name = "ability_4_cast"
```

---

## 6B. BODY CATEGORY PASSIVE SYSTEM

Each body category grants a passive ability (see GDD §2.3.6). Passives are implemented as modular components that hook into existing systems.

```gdscript
# passive_system.gd — Component on the Player node
extends Node

var active_passive: String = ""
var passive_handlers: Dictionary = {}  # passive_id -> Callable

func _ready():
    passive_handlers = {
        "adaptable": _passive_adaptable,
        "trample": _passive_trample,
        "constrict": _passive_constrict,
        "web_sense": _passive_web_sense,
        "airborne": _passive_airborne,
        "absorption": _passive_absorption,
        "hover": _passive_hover,
        "endurance": _passive_endurance,
        "construct": _passive_construct,
        "flutter": _passive_flutter,
    }

func activate(passive_id: String) -> void:
    if active_passive != "":
        deactivate()
    active_passive = passive_id
    if passive_id in passive_handlers:
        passive_handlers[passive_id].call()

func deactivate() -> void:
    # Remove all passive effects — disconnect signals, remove modifiers
    _clear_all_passive_effects()
    active_passive = ""
```

**Passive implementation patterns:**

| Passive | Implementation Approach |
|---------|----------------------|
| **Adaptable** (Bipedal) | Modifier on AbilityCooldownTimers: multiply all cooldown durations by 0.95 |
| **Trample** (Quadruped) | Area2D check on player movement: if overlapping Fodder enemy while MOVING state, deal 5 damage + stagger. Modifier on knockback_force: multiply by 1.15 |
| **Constrict** (Serpentine) | Hook into damage pipeline: if target has "entangled" status, multiply damage by 1.3. Register immunity to "entangled" in StatusEffectManager |
| **Web Sense** (Arachnid) | Expand minimap detection: enemies within 5 tiles always shown. Hook into damage pipeline: if target was unaware (not in chase/attack state), multiply damage by 1.25 |
| **Airborne** (Avian) | Hazard immunity layer: add player to "ground_hazard_immune" group while velocity > 0. Remove after 1.5s of velocity == 0. Modifier on ranged ability range: multiply by 1.1 |
| **Absorption** (Amorphous) | Hook into damage pipeline: multiply physical (element=="") damage by 0.8. On damage taken, add 15% of pre-mitigation damage as Essence. Modifier on StatusEffectManager: multiply all incoming status durations by 0.5 |
| **Hover** (Floating) | Permanent hazard immunity (no velocity check unlike Avian). Register immunity to "entangled". Projectile abilities ignore destructible terrain collision layer |
| **Endurance** (Arthropod) | Register immunity to knockback (knockback_force always 0). Cap stun duration at 0.5s in StatusEffectManager. Add 1 HP/s passive regen in _physics_process |
| **Construct** (Geometric) | Register immunity to "poisoned" and "burning" in StatusEffectManager. Register vulnerability: Earth element damage multiplied by 1.25. Modifier on ability damage: multiply by 1.1 |
| **Flutter** (Insectoid) | Modifier on dodge_cooldown: multiply by 0.6. Modifier on dodge_stamina_cost: multiply by 0.5. Monitor HP: when below 30%, add speed modifier of 1.2 |

---

## 7. CREATURE FORM RENDERING

### 7.1 Approach: Sprite Swap with Shared Animation Rigs

Creature forms are implemented as **AnimatedSprite2D frame sets** sharing **animation timing rigs per body category**. This is NOT runtime mesh morphing or shader blending — it is discrete sprite swapping with smooth transitions.

**How it works:**
1. Each body category (bipedal, quadruped, serpentine, etc.) has a **shared AnimationPlayer** with keyframed timing for all actions (idle, run, dodge, attack_light, attack_heavy, ability_1-4, hurt, death).
2. Each creature form within a body category has its own **SpriteFrames** resource containing the actual pixel art for each animation.
3. Changing creature form = swapping the `SpriteFrames` resource on the `AnimatedSprite2D`, NOT rebuilding the animation tree.
4. All creature forms within a body category have **identical frame counts and timing** per animation. A bipedal Efreet "idle" has the same frame count and duration as a bipedal Human "idle".

### 7.2 Creature Form Transition

When the player's creature form changes mid-run:

```gdscript
# player_visual.gd

func transition_to_form(new_form_id: String, duration: float = 1.5) -> void:
    var new_frames: SpriteFrames = CreatureFormDB.get_frames(new_form_id)
    var new_body_category: String = CreatureFormDB.get_body_category(new_form_id)
    
    # Phase 1: Current form dissolves (0.75s)
    var tween = create_tween()
    tween.tween_property(body_sprite, "modulate:a", 0.0, duration / 2.0)
    
    # Spawn particle burst at midpoint
    tween.tween_callback(func():
        emit_morph_particles()
        body_sprite.sprite_frames = new_frames
        
        # If body category changed, swap animation rig
        if new_body_category != current_body_category:
            swap_animation_rig(new_body_category)
            current_body_category = new_body_category
    )
    
    # Phase 2: New form materializes (0.75s)
    tween.tween_property(body_sprite, "modulate:a", 1.0, duration / 2.0)
    
    current_form_id = new_form_id
```

### 7.3 Visual Tier Rendering

Each creature form has 4 visual tiers (1–4) plus the universal Tier 0 stick figure. Visual tiers are implemented as **separate SpriteFrames resources** within the same creature form folder:

```
assets/sprites/player/creatures/phoenix/
├── phoenix_tier1.tres      # SpriteFrames — sketch-level
├── phoenix_tier2.tres      # SpriteFrames — draft-level
├── phoenix_tier3.tres      # SpriteFrames — rendered
└── phoenix_tier4.tres      # SpriteFrames — ascended
```

Tier transitions use the same dissolve-and-reform animation as form transitions, but shorter (0.5s).

### 7.4 Phase 1 Visual Implementation (Stick Figure Only)

For Phase 1, only the stick figure exists. The stick figure is drawn procedurally using `_draw()` on a custom `Node2D`, NOT as a sprite sheet. This makes it easier to prototype animation and eventually add the "lines thickening" effect for Tier 1.

```gdscript
# stick_figure.gd
extends Node2D

var line_width := 2.0
var color := Color.BLACK
var limb_positions := {}  # Updated by animation system

func _draw():
    # Head (circle)
    draw_circle(limb_positions.get("head", Vector2(0, -28)), 5.0, color)
    
    # Body line
    draw_line(limb_positions.get("neck", Vector2(0, -23)),
              limb_positions.get("hip", Vector2(0, -5)), color, line_width)
    
    # Arms
    draw_line(limb_positions.get("l_shoulder", Vector2(-2, -20)),
              limb_positions.get("l_hand", Vector2(-12, -10)), color, line_width)
    draw_line(limb_positions.get("r_shoulder", Vector2(2, -20)),
              limb_positions.get("r_hand", Vector2(12, -10)), color, line_width)
    
    # Legs
    draw_line(limb_positions.get("l_hip", Vector2(-2, -5)),
              limb_positions.get("l_foot", Vector2(-8, 10)), color, line_width)
    draw_line(limb_positions.get("r_hip", Vector2(2, -5)),
              limb_positions.get("r_foot", Vector2(8, 10)), color, line_width)

func set_pose(pose: Dictionary) -> void:
    limb_positions = pose
    queue_redraw()
```

**Stick figure animations** are defined as pose keyframes (dictionary of position vectors), interpolated by the AnimationPlayer. This gives smooth, natural movement to the stick figure without needing sprite sheets.

---

## 8. SAVE SYSTEM

### 8.1 Save File Location

```gdscript
const SAVE_PATH := "user://save_data.json"
```

Godot's `user://` maps to:
- Windows: `%APPDATA%/Godot/app_userdata/BlankSlate/`
- Linux: `~/.local/share/godot/app_userdata/BlankSlate/`
- macOS: `~/Library/Application Support/Godot/app_userdata/BlankSlate/`

Steam Cloud will sync this file (configured in Steamworks dashboard).

### 8.2 Save Manager Implementation

```gdscript
# save_manager.gd (Autoload)
extends Node

var data: Dictionary = {}

func _ready():
    load_game()

func load_game() -> void:
    if FileAccess.file_exists(SAVE_PATH):
        var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
        var json = JSON.new()
        var err = json.parse(file.get_as_text())
        file.close()
        if err == OK:
            data = json.get_data()
        else:
            push_error("Save file corrupted, creating new save")
            create_new_save()
    else:
        create_new_save()

func save_game() -> void:
    var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    file.store_string(JSON.stringify(data, "\t"))
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
        "bestiary": [],
        "statistics": {
            "total_runs": 0,
            "highest_floor": 0,
            "total_enemies_killed": 0,
            "total_combinations_performed": 0,
            "bosses_defeated": {},
            "total_echoes_earned": 0,
            "total_play_time_seconds": 0
        },
        "modifiers_active": [],
        "tower_cleared": false,
        "tutorial_complete": false,
        "total_runs_started": 0,
        "run_history_visuals": [],
        "most_used_element": "",
        "least_used_element": "",
        "primordial_affinity": {
            "pyraxis": 0.0, "thalassa": 0.0, "ouranos": 0.0,
            "lithara": 0.0, "solenne": 0.0, "nythara": 0.0
        },
        "lore_tablet_26_unlocked": false
    }
    save_game()
```

**Auto-save triggers:** Save after every: hub structure purchase, NPC unlock, run end (death or completion), lore tablet discovery, combination discovery. NOT during runs for gameplay state — in-run state is memory-only.

---

## 9. AUDIO ARCHITECTURE

### 9.1 Audio Bus Layout

```
Master
├── Music          # Volume: -6dB default
│   ├── MusicA     # For crossfading
│   └── MusicB     # For crossfading
├── SFX            # Volume: 0dB default
│   ├── Player     # Player actions
│   ├── Enemy      # Enemy actions
│   ├── UI         # Menu sounds
│   └── Ambient    # Environmental loops
└── Voice          # NPC/Primordial lines (Volume: 0dB)
```

### 9.2 Music Crossfade

```gdscript
# audio_manager.gd (Autoload)
extends Node

@onready var music_a: AudioStreamPlayer = $MusicA
@onready var music_b: AudioStreamPlayer = $MusicB
var active_player: AudioStreamPlayer

func crossfade_to(stream: AudioStream, duration: float = 2.0) -> void:
    var next = music_b if active_player == music_a else music_a
    next.stream = stream
    next.volume_db = -40.0
    next.play()
    
    var tween = create_tween().set_parallel(true)
    tween.tween_property(active_player, "volume_db", -40.0, duration)
    tween.tween_property(next, "volume_db", -6.0, duration)
    
    await tween.finished
    active_player.stop()
    active_player = next
```

### 9.3 SFX Pooling

Rather than creating/destroying `AudioStreamPlayer2D` nodes constantly, use a pool:

```gdscript
# sfx_pool.gd

var pool: Array[AudioStreamPlayer2D] = []
const POOL_SIZE := 16

func _ready():
    for i in POOL_SIZE:
        var player = AudioStreamPlayer2D.new()
        player.bus = "SFX"
        add_child(player)
        pool.append(player)

func play_sfx(stream: AudioStream, position: Vector2, 
              volume_db: float = 0.0, pitch: float = 1.0) -> void:
    for player in pool:
        if not player.playing:
            player.stream = stream
            player.global_position = position
            player.volume_db = volume_db
            player.pitch_scale = pitch
            player.play()
            return
    # All players busy — skip this sound (acceptable)
```

---

## 10. UI SYSTEM

### 10.1 HUD Node Hierarchy

```
HUD (CanvasLayer, layer 10)
├── TopLeft (VBoxContainer)
│   ├── HPBar (TextureProgressBar)
│   ├── StaminaBar (TextureProgressBar)
│   └── UltimateCharge (Control + custom draw)
├── TopRight (Control)
│   └── Minimap (SubViewportContainer)
│       └── SubViewport
│           └── MinimapCamera (Camera2D)
├── BottomLeft (HBoxContainer)
│   ├── Consumable1 (TextureRect + Label)
│   ├── Consumable2 (TextureRect + Label)
│   └── Consumable3 (TextureRect + Label)
├── BottomCenter (HBoxContainer)
│   ├── Ability1Icon (TextureRect + CooldownOverlay)
│   ├── Ability2Icon (TextureRect + CooldownOverlay)
│   ├── Ability3Icon (TextureRect + CooldownOverlay)
│   └── Ability4Icon (TextureRect + CooldownOverlay)
├── BottomRight (VBoxContainer)
│   ├── ElementDisplay (HBoxContainer)    # Active element icons
│   └── EssenceCounter (Label)
├── BossHPBar (TextureProgressBar)        # Hidden unless boss fight, centered top
├── FloorLabel (Label)                    # "Floor 7 / 25 — Water: The Drowned City"
└── DamageNumbersLayer (Node2D)           # Floating damage numbers spawned here
```

### 10.2 Floating Damage Numbers

```gdscript
# damage_number.gd
extends Node2D

@onready var label: Label = $Label

func setup(damage: float, element: String, is_combo: bool) -> void:
    label.text = str(int(damage))
    
    if is_combo:
        label.add_theme_color_override("font_color", Color.YELLOW)
        label.add_theme_font_size_override("font_size", 16)
    elif element != "":
        label.add_theme_color_override("font_color", 
            ElementDB.get_element(element).color_primary)
    
    # Float upward and fade
    var tween = create_tween().set_parallel(true)
    tween.tween_property(self, "position:y", position.y - 40, 0.8)
    tween.tween_property(self, "modulate:a", 0.0, 0.8).set_delay(0.3)
    tween.chain().tween_callback(queue_free)
```

---

## 11. SCENE MANAGEMENT AND GAME FLOW

### 11.1 Scene Tree

```
Root (Window)
└── GameManager (Autoload — handles scene transitions)
    └── CurrentScene (Node)              # Swapped by GameManager
        ├── MainMenu                     # OR
        ├── Hub                          # OR
        └── TowerRun                     # Contains the active run
            ├── CurrentRoom (Node2D)     # Swapped per room
            ├── Player                   # Persists across rooms within a run
            ├── HUD                      # Persists across rooms
            └── RunState (Resource)      # In-memory run data
```

### 11.2 Game Flow State Machine

```
BOOT → MAIN_MENU → HUB ←→ TOWER_RUN
                     ↑          │
                     │     ROOM_TRANSITION
                     │          │
                     ├── DEATH ←┘
                     │
                     └── VICTORY (tower clear)
```

```gdscript
# game_manager.gd (Autoload)
extends Node

enum GameState { MAIN_MENU, HUB, TOWER_RUN, PAUSED, ROOM_TRANSITION, 
                 DEATH_SCREEN, VICTORY_SCREEN }

var state: GameState = GameState.MAIN_MENU
var current_scene: Node = null
var run_state: RunState = null  # Only exists during TOWER_RUN

func change_scene(scene_path: String) -> void:
    if current_scene:
        current_scene.queue_free()
    
    var packed = load(scene_path) as PackedScene
    current_scene = packed.instantiate()
    get_tree().root.add_child(current_scene)

func start_run() -> void:
    run_state = RunState.new()
    run_state.initialize(SaveManager.data)
    state = GameState.TOWER_RUN
    change_scene("res://scenes/main/tower_run.tscn")

func end_run(cause: String) -> void:
    # Capture run-end snapshot for hub character averaging
    var snapshot = {
        "elements": run_state.held_elements.duplicate(),
        "visual_tier": run_state.current_visual_tier
    }
    SaveManager.data["run_history_visuals"].append(snapshot)
    if SaveManager.data["run_history_visuals"].size() > 10:
        SaveManager.data["run_history_visuals"].pop_front()
    
    # Award echoes
    SaveManager.data["echoes"] += run_state.echoes_earned
    SaveManager.save_game()
    
    run_state = null
    
    if cause == "victory":
        state = GameState.VICTORY_SCREEN
        # Show victory screen, then return to hub
    else:
        state = GameState.DEATH_SCREEN
        # Show run summary, then return to hub
```

### 11.3 Run State (In-Memory Only)

```gdscript
# run_state.gd
class_name RunState
extends RefCounted

var current_floor: int = 1
var current_zone_position: int = 1      # 1-5
var zone_elements: Array[String] = []   # e.g. ["WATER", "FIRE", "LIGHT", "EARTH"]
var zone_biome_variants: Array[String] = []
var held_elements: Array[String] = []   # Current element loadout (max 4)
var hp: float = 100.0
var max_hp: float = 100.0
var stamina: float = 100.0
var max_stamina: float = 100.0
var essence: int = 0
var consumables: Array[String] = ["", "", ""]
var echoes_earned: int = 0
var enemies_killed: int = 0
var combinations_performed: int = 0
var current_visual_tier: int = 0
var current_creature_form: String = "stick_figure"
var ultimate_charge: float = 0.0
var discovered_combos_this_run: Array[String] = []
var floors_cleared_no_damage: Array[int] = []

func initialize(save_data: Dictionary) -> void:
    # Apply meta-progression bonuses
    var armory_tier = save_data.get("hub_structures", {}).get("armory_tier", 0)
    max_hp += armory_tier * 10.0
    hp = max_hp
    
    var stamina_tier = save_data.get("hub_structures", {}).get("stamina_forge_tier", 0)
    max_stamina += stamina_tier * 10.0
    stamina = max_stamina
    
    # Generate zone configuration
    _generate_zones(save_data)

func _generate_zones(save_data: Dictionary) -> void:
    var all_elements = ["FIRE", "WATER", "AIR", "EARTH", "LIGHT", "DARK"]
    var available = all_elements.filter(func(e): 
        return e in save_data.get("unlocked_elements", ["FIRE", "WATER"]))
    
    available.shuffle()
    zone_elements = available.slice(0, 4)
    
    # Select biome variants
    var biome_db = BiomeDB  # Autoload with all biome variant data
    for element in zone_elements:
        var variants = biome_db.get_variants_for_element(element)
        zone_biome_variants.append(variants.pick_random())
```

---

## 12. INPUT MAPPING

### 12.1 Default Bindings

| Action | Keyboard | Controller (Xbox) |
|--------|----------|-------------------|
| `move_up` | W | Left Stick Up |
| `move_down` | S | Left Stick Down |
| `move_left` | A | Left Stick Left |
| `move_right` | D | Left Stick Right |
| `attack_light` | Left Mouse | X |
| `attack_heavy` | Right Mouse | Y |
| `dodge` | Space | B |
| `sprint` | Shift | A (hold) |
| `ability_1` | Q | LB |
| `ability_2` | E | RB |
| `ability_3` | R | LT |
| `ability_4` | F | RT |
| `ultimate` | V | LB+RB simultaneous |
| `consumable_1` | 1 | D-Pad Left |
| `consumable_2` | 2 | D-Pad Up |
| `consumable_3` | 3 | D-Pad Right |
| `interact` | E (context) | A |
| `pause` | Escape | Start |
| `map` | Tab | Select |

### 12.2 Controller Detection

```gdscript
# input_manager.gd (Autoload)

var using_controller: bool = false

func _input(event: InputEvent) -> void:
    if event is InputEventJoypadButton or event is InputEventJoypadMotion:
        if not using_controller:
            using_controller = true
            emit_signal("input_device_changed", "controller")
    elif event is InputEventKey or event is InputEventMouseButton:
        if using_controller:
            using_controller = false
            emit_signal("input_device_changed", "keyboard")
```

HUD button prompts update automatically when `input_device_changed` fires.

---

## 13. PERFORMANCE BUDGET

| System | Budget | Implementation Note |
|--------|--------|---------------------|
| Entities (enemies + player) | Max 50 simultaneous | Use object pooling for projectiles |
| Particles (GPUParticles2D) | 500 particles/frame | Use particle pooling, reduce emission on low settings |
| Physics bodies | Max 100 | Disable collision on off-screen entities |
| Draw calls | Target < 200 | Use texture atlases, batch sprites |
| Audio streams | Max 16 simultaneous SFX | SFX pool of 16 players |
| Room load time | < 1 second | Pre-load next room during gameplay |
| Frame time | 16.67ms (60 FPS) | Profile regularly, optimize hot paths |

### 13.1 Object Pooling Pattern

```gdscript
# object_pool.gd
class_name ObjectPool
extends Node

var pool: Array[Node] = []
var scene: PackedScene
var pool_size: int

func _init(packed_scene: PackedScene, size: int = 20):
    scene = packed_scene
    pool_size = size

func _ready():
    for i in pool_size:
        var instance = scene.instantiate()
        instance.visible = false
        instance.set_process(false)
        instance.set_physics_process(false)
        add_child(instance)
        pool.append(instance)

func get_instance() -> Node:
    for obj in pool:
        if not obj.visible:
            obj.visible = true
            obj.set_process(true)
            obj.set_physics_process(true)
            return obj
    # Pool exhausted — expand
    var new_obj = scene.instantiate()
    add_child(new_obj)
    pool.append(new_obj)
    return new_obj

func return_instance(obj: Node) -> void:
    obj.visible = false
    obj.set_process(false)
    obj.set_physics_process(false)
```

Use pools for: projectiles, damage numbers, particle effects, enemy spawns.

---

## 14. PHASE 1 — EXACT BUILD SPECIFICATION

This section tells Claude Code exactly what to build for Phase 1 and in what order. Every file, every node, every number.

### Step 1: Project Setup

1. Create a new Godot 4.3 project named `blank_slate`
2. Set Project Settings:
   - `display/window/size/viewport_width`: 960
   - `display/window/size/viewport_height`: 540
   - `display/window/size/window_width_override`: 1920
   - `display/window/size/window_height_override`: 1080
   - `display/window/stretch/mode`: `canvas_items`
   - `display/window/stretch/aspect`: `keep`
   - `rendering/renderer/rendering_method`: `forward_plus` (or `gl_compatibility` for wider hardware support)
3. Configure collision layers as specified in §2.1
4. Set up input actions as specified in §12.1
5. Create folder structure matching GDD §11.1

### Step 2: Player Character

Build the player scene exactly matching §2 of this document. Implement:
- `CharacterBody2D` with circle collision (radius 10px — Bipedal default, will change with body category in Phase 7)
- Stick figure rendering via `_draw()` (§7.4)
- Body-category-driven movement system (§2.3) — initialize with Bipedal defaults: speed 150 px/s, hitbox radius 10px, HP modifier 1.0x
- Sprint at 1.5x speed, costs 10 stamina/s
- Dodge roll: 350 px/s, 0.4s duration, 0.2s i-frames, 0.5s cooldown, costs 25 stamina (all Bipedal defaults)
- State machine: IDLE, MOVING, DODGING, ATTACKING, HURT, DEATH (§2.2)
- Input buffering (§2.4)
- HP: 100, Stamina: 100, Stamina regen: 15/s with 1s pause after use
- `apply_body_category()` method ready for future use — hardcoded to Bipedal for Phase 1

**Stick figure animations to implement:**
- idle: subtle body oscillation (breathing)
- run: legs alternating, arms swinging
- dodge: body tucks into ball shape
- attack_light: right arm swings forward (3-hit combo: timing 0.3s, 0.3s, 0.4s)
- attack_heavy: both arms raise, slam down (0.8s)
- hurt: body recoils backward
- death: limbs collapse, falls flat

**Light attack combo:**
- Hit 1: 8 damage, right punch, small hitbox
- Hit 2: 8 damage, left punch, small hitbox
- Hit 3: 12 damage, kick, slightly larger hitbox
- If no input within 0.4s after a hit, combo resets
- Each hit has 0.05s hit stop

**Heavy attack:**
- 20 damage, small AoE (radius 30px), slight knockback (60 force)
- 0.8s total (0.3s windup, 0.2s active, 0.3s recovery)
- 0.05s hit stop

### Step 3: Single Room

Build one room scene:
- Isometric TileMap, 12×12 tiles (64×32 per tile)
- Floor tiles: simple grey checkerboard (placeholder)
- Wall tiles around the perimeter with collision
- 4 indestructible pillars (StaticBody2D, 1×1 tile each) at positions (3,3), (3,8), (8,3), (8,8)
- `NavigationRegion2D` with baked navmesh (exclude walls and pillars)
- 4 spawn points (Marker2D) at positions (2,2), (2,9), (9,2), (9,9)
- Player spawn at (6, 10) (bottom center)
- Camera2D on the player, limits set to room bounds

### Step 4: Single Enemy (Stone Grunt)

Build one enemy matching §3 of this document:
- `CharacterBody2D` with circle collision (radius 8px)
- Simple sprite: colored circle (dark red, 16px diameter) as placeholder
- HP: 30
- Movement speed: 80 px/s
- Detection radius: 150px
- Attack: melee punch, 10 damage, 0.6s attack animation, 0.4s telegraph (red circle under target), 1.5s cooldown, range 25px
- Behavior tree: Patrol → Chase (if detected) → Attack (if in range)
- Pathfinding via NavigationAgent2D
- Drops 2 Essence on death
- Shows floating damage numbers when hit
- Health bar appears above when first damaged
- Hit stop on receiving damage

### Step 5: Room Combat Loop

1. Player enters room → doors lock (change door sprites to "closed")
2. Enemies spawn from spawn points (with 0.5s stagger between spawns)
3. Player fights enemies
4. When all enemies are dead → doors unlock → "Exit" indicator appears on north door
5. Player walks to north door → triggers room transition
6. Next room loads (for Phase 1, just reload the same room with new enemies)

### Step 6: HP, Stamina, and Death

- HUD: HP bar (green→yellow→red) top left, Stamina bar (blue) below it
- When player HP reaches 0:
  - Play death animation (1s)
  - Fade to black (0.5s)
  - Show death screen: "You Died" + "Floor Reached: 1" + "Enemies Killed: X"
  - "Return to Hub" button (for Phase 1, just restart the room)
- Essence counter displayed bottom right (simple number)

### Step 7: Three-Room Run

Chain 3 rooms together:
- Room 1: 2 Stone Grunts
- Room 2: 3 Stone Grunts
- Room 3: 4 Stone Grunts (one is slightly faster — 100 px/s — as a mini-elite preview)
- After room 3, display "Run Complete!" screen with stats
- Loop back to room 1 on restart

### Phase 1 Acceptance Criteria

The build is complete when ALL of the following are true:
- [ ] Player can move in 8 directions with smooth isometric feel
- [ ] Sprint works and drains stamina
- [ ] Dodge roll has i-frames (player passes through enemy attacks during first 0.2s)
- [ ] Light attack 3-hit combo works with correct timing windows
- [ ] Heavy attack has visible windup and AoE
- [ ] Hit stop triggers on every successful hit
- [ ] Input buffering allows dodge during attack recovery
- [ ] Stone Grunts pathfind around pillars
- [ ] Stone Grunts telegraph attacks with ground indicator
- [ ] Damage numbers float above hit targets
- [ ] Enemy health bars appear when damaged
- [ ] Room doors lock during combat and unlock when clear
- [ ] Room transitions work (3 rooms in sequence)
- [ ] HP bar changes color at thresholds
- [ ] Stamina regenerates after 1s pause
- [ ] Death triggers death screen with stats
- [ ] Run completion triggers summary screen
- [ ] 60 FPS stable with 4 enemies + player + particles

---

## 15. PHASE 2 — EXACT BUILD SPECIFICATION

After Phase 1 is working, Phase 2 adds the element system.

### Step 1: Element Data System

1. Create `ElementData`, `AbilityData`, and `UltimateData` resource classes (§6.1–6.3)
2. Create `.tres` resource files for Fire, Water, and Steam using the exact definitions in §6.4–6.6
3. Create `ElementDB` autoload that loads all element resources and provides lookup functions
4. Create `element_manager.gd` component for the player: tracks held elements (max 4), emits signals on change

### Step 2: Ability System

1. Add ability slot UI to HUD (4 icons, bottom center, show cooldown sweep)
2. When player acquires an element, populate ability slots from the element's `AbilityData`
3. Implement ability execution pipeline:
   - Check cooldown → check stamina cost → play cast animation → spawn hitbox/projectile → start cooldown timer
4. Implement all 4 Fire abilities (§6.4):
   - Fireball: projectile (use Projectile system from §5.3)
   - Flame Wave: cone hitbox (custom shape, active for 0.2s)
   - Ember Dash: movement ability (dash + spawn fire trail Area2Ds)
   - Inferno: large AoE around player
5. Implement all 4 Water abilities (§6.5):
   - Tide Shot: projectile + water puddle at impact
   - Riptide: AoE pull (negative knockback)
   - Aqua Shift: teleport + i-frames + puddles
   - Tsunami: moving wave hitbox

### Step 3: Element Shrine

1. Create Element Shrine room scene (special room, non-combat)
2. Display 2–3 element choices as interactable pedestals
3. Player walks to a pedestal and presses Interact to acquire that element
4. On acquisition: populate ability slots, trigger visual tier change signal

### Step 4: Combination Altar

1. Create Combination Altar room scene (special room, non-combat)
2. If player holds Fire and Water, altar offers "Steam" combination
3. Display: "Combine Fire + Water → ???" (or "→ Steam" if already discovered)
4. On accept: remove Fire and Water from held elements, add Steam, update abilities to Steam set (§6.6)
5. If first discovery: play discovery animation, add to save data `discovered_combinations`

### Step 5: Visual Tier Transition

1. When first element is acquired: stick figure lines thicken from 2px to 3px, faint color wash appears (element's `color_primary` at 20% opacity)
2. This is the Tier 0 → Tier 1 transition
3. For Phase 2, only Tier 0 and Tier 1 need to work — higher tiers come in Phase 7

### Step 6: Five-Room Run with Events

Restructure the run to 5 rooms:
- Room 1: Combat (2 enemies)
- Room 2: Element Shrine
- Room 3: Combat (3 enemies)
- Room 4: Combination Altar (if player has 2 combinable elements)
- Room 5: Combat (4 enemies)

### Phase 2 Acceptance Criteria

- [ ] Fire abilities all work with correct damage, cooldown, and visual effects
- [ ] Water abilities all work with correct damage, cooldown, and visual effects
- [ ] Steam abilities all work after combining Fire + Water
- [ ] Element Shrine presents choices and grants element on interaction
- [ ] Combination Altar correctly detects combinable elements and performs combination
- [ ] Ability cooldown UI shows sweep animation
- [ ] Stick figure color tints on element acquisition
- [ ] Combination discovery saves to persistent save data
- [ ] Projectiles collide correctly with enemies and walls
- [ ] Water puddles persist and are visible
- [ ] Ember Dash trail damages enemies that walk through it

---

*End of Technical Implementation Guide — Blank Slate v1.0*
