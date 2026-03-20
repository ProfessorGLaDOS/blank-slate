# BLANK SLATE — Game Design Document v1.0

## Implementation Target
- **Engine:** Godot 4.x (GDScript primary, C# for performance-critical systems)
- **Platform:** Steam (Windows, Linux, Mac)
- **Perspective:** Isometric 2.5D
- **Genre:** Real-time action roguelike tower climber
- **Run Length:** 2–3+ hours per full run (25 floors)
- **Session Target:** 10+ hours to first tower completion; 50+ hours for full meta-progression

---

## 1. CORE CONCEPT

The player begins every run as a **stick figure** — a literal blank slate. As they ascend a procedurally generated tower floor by floor, they collect **elemental abilities** that combine through an alchemy-inspired chain system. Each element acquired visually transforms the character, evolving from simple stick figure to a fully-realized elemental warrior. Death resets everything — visual form, abilities, progress — back to the stick figure. Between runs, persistent **meta-progression** unlocks new elements, combination recipes, hub upgrades, NPCs, and tower zones.

### Design Pillars
1. **Visual Identity = Build Identity.** The player's character appearance is a direct, readable expression of their current ability loadout. Two players with different builds should look visibly different by floor 5.
2. **Combinatorial Depth.** The alchemy chain system means the number of possible builds grows geometrically. A "Fire+Water=Steam, Steam+Earth=Mud Geyser" chain creates emergent gameplay the designer doesn't need to hand-craft.
3. **Pure Permadeath Tension.** Full reset on death. No safety nets. The meta-progression makes future runs *different*, not easier.
4. **Readable Combat.** Isometric real-time action must be visually clear. Every attack, element, and enemy telegraph must be instantly parseable despite the visual complexity of late-game elemental builds.

---

## 1B. NARRATIVE AND LORE

### 1B.1 The Premise — The Unmaking and The Choice

The old world is gone.

Not destroyed — *expired*. Reality has a lifespan, and the previous universe reached the end of its. Every law of physics, every star, every civilization, every blade of grass — unwound into raw potential. What remains is not nothing, but *everything*, compressed into a single point of infinite possibility.

From this potential, a new world is being forged. But a world needs a template — a pattern for life to follow. In the old world, life took billions of years to emerge through chance. The architects of the new world — the **Primordials** — have decided to be more deliberate this time. They've chosen a single soul from the countless trillions that existed in the old world to serve as the **Mold**: the living template from which all new life will be cast.

That soul is the player.

The problem: the soul arrives *blank*. Stripped of its old form, its old identity, its old biology. It is nothing — a stick figure sketch of what a being could be. To become the Mold, it must climb the **Crucible** — a tower built from the raw elements of creation — and forge itself into something worthy. Whatever form it takes at the summit will become the seed-pattern for all life in the new world.

Every run is an attempt. Every death is a rejection — *not yet worthy, try again.* Every element absorbed shapes what the soul could become. And the Primordials are watching.

### 1B.2 The Primordials — Elemental Architects

The Primordials are not gods in the worshipful sense. They are **forces** — the fundamental principles that will govern the new world. They existed before the old world and will exist after the new one expires too. Each Primordial embodies one of the six base elements, and each has its own vision for what life in the new world should look like.

| Primordial | Element | Title | Philosophy | Preferred Form |
|-----------|---------|-------|-----------|---------------|
| **Pyraxis** | Fire | The Furnace | Life should burn. Existence is consumption — you eat, you grow, you blaze, you expire, and something new rises from your ash. Stagnation is the only true death. | Efreet, Phoenix, Solar Dragon — anything that burns |
| **Thalassa** | Water | The Deep | Life should flow. Adaptation is survival — the creature that changes shape to fit its container will outlast the one that breaks against the current. Rigidity is extinction. | Leviathan-kin, Ooze, Jellyfish — anything that flows |
| **Ouranos** | Air | The Breath | Life should soar. Freedom is the highest state — no creature should be bound to the earth when the sky exists. The cage is the enemy, whether built of stone or habit. | Zephyr, Phoenix, Angel — anything that flies |
| **Lithara** | Earth | The Root | Life should endure. Deep roots survive the storm that topples the tall tree. Strength is patience. Permanence is the gift. Everything else is noise. | Golem, Mammoth, Centaur — anything that stands firm |
| **Solenne** | Light | The Beacon | Life should illuminate. To shine is to exist — the creature that radiates warmth and clarity has already found its purpose. Darkness is not the absence of light; it is the space waiting to be filled. | Seraph, Angel, Nereid — anything that illuminates |
| **Nythara** | Dark | The Veil | Life should dream. The seen world is the surface; the real world is underneath, in shadow, in sleep, in the space between thoughts. Those who fear the dark fear themselves. | Wraith, Kraken, Banshee — anything that hides |

**The Primordials are not in conflict** — not exactly. They all agree that a new world must be built. They disagree on what life should *be*. The Crucible is their compromise: rather than argue for eternity, they built an arena where a single soul would be shaped by exposure to all six elements. Whatever the soul becomes, that's what life will be. They trust the process, even if each of them is quietly stacking the deck.

### 1B.3 The Crucible — Why a Tower?

The Crucible is not a building. It is a **testing apparatus** — a structure woven from raw creation-stuff by the Primordials specifically to stress-test the soul. Each zone position represents a different stage of the forging process, regardless of which element occupies it:

| Zone Position | Narrative Purpose | What the Primordials Are Testing |
|--------------|------------------|----------------------------------|
| **First Zone** (1–5) | The raw materials. The soul's first encounter with elemental force. Whichever Primordial's domain this is, they go easy — but not too easy. | Can this soul survive at all? Can it fight, adapt, endure the simplest challenges? This is the filter. Most souls would fail here. |
| **Second Zone** (6–10) | Submersion. The soul is immersed in a new element — forced to adapt after the comfort of the first zone. Nothing is straightforward here. | Can this soul navigate uncertainty? Can it adapt when the rules change? Life in the new world will face problems without obvious solutions. |
| **Third Zone** (11–15) | Exposure. The challenge is fully realized now. The Primordial of this zone holds nothing back. | Can this soul act without a safety net? Can it commit to a direction when everything is trying to knock it off course? Life must be bold enough to leap. |
| **Fourth Zone** (16–20) | Reflection. The soul is forced to confront itself against the most demanding expression of an element. Every flaw is exposed. | Does this soul know what it is? Has it been shaping itself deliberately, or just reacting? Life in the new world needs intention, not accident. |
| **The Apex** (21–25) | Synthesis. Everything at once. All elements in chaos. The final test. Always the same zone, always the hardest. | Is this soul *complete*? Can it hold its form when every force in creation pulls it in a different direction? The Mold must be unshakeable. |

The tower is procedurally generated because the Primordials rebuild it for each attempt. They're not sadistic — they're thorough. Every run is a new configuration — different elements, different biomes, different bosses — because a Mold that can only survive one specific arrangement of challenges isn't a good template for life. Life needs to handle the unexpected.

### 1B.4 Death and Permadeath — The Reset

When the soul dies in the Crucible, it doesn't cease to exist. It is **unraveled** — returned to its blank state, stripped of every element it had absorbed, every form it had taken. The Primordials reset the Crucible and allow the soul to try again.

This is not punishment. It is *refinement*. Each death teaches the soul something that persists not in its body or its powers, but in its **memory** — the meta-progression. The Echoes the player earns are literally the residue of past attempts, impressions left on the fabric of the Crucible by the soul's repeated passage through it. The hub structures built with Echoes are physical manifestations of lessons learned.

The Keeper (the first NPC) explains this plainly in early dialogue: *"You will die. Many times. That is the purpose. A blade is not forged in a single strike."*

### 1B.5 The Bastion — Memory Made Real

The Bastion exists outside the Crucible, in a liminal space between the expired old world and the unborn new one. It is built from Echoes — the impressions of past runs — which is why it starts as a bare stone platform and grows as the player invests.

**The hub character's appearance** (the averaged creature form from past runs) has narrative weight: it is how the Primordials currently perceive the soul. A player who consistently runs Fire builds is being perceived as a fire-being. The Primordials respond to this — their dialogue shifts subtly based on the hub character form:

- A player whose hub form is a **Phoenix** might hear Pyraxis's voice more prominently in Lore Tablets, with approving commentary.
- A player whose hub form is **balanced human** might find that all six Primordials speak to them equally, with a tone of curiosity — a balanced Mold is unexpected.
- A player whose hub form keeps changing (diverse run history) might hear the Primordials debating among themselves.

### 1B.6 NPCs — Echoes of the Old World

The NPCs in the Bastion are not living beings. They are **echoes** — fragments of souls from the old world that were considered for the role of Mold but rejected or who declined. They persist in the liminal space because they left strong enough impressions. Each NPC represents a different attitude toward the Crucible and the task of shaping new life:

| NPC | Narrative Identity | Attitude |
|-----|-------------------|----------|
| **The Keeper** | The last Mold candidate before the player. Climbed to Floor 20 before choosing to step aside. Now serves as a guide — not because they're required to, but because they believe in the process. | Patient, encouraging, occasionally melancholy. Knows more than they say. Hints that they chose to stop climbing for a reason they won't yet explain. |
| **The Alchemist** | A soul from the old world who was a scholar of elemental theory. Fascinated by how the six elements interact. Never attempted the Crucible — they preferred to study it from outside. | Enthusiastic, nerdy, obsessive. Treats element combinations like a puzzle to be solved. Occasionally forgets the player is a person, not a research subject. Speaks in excited run-on sentences when a new combo is discovered. |
| **The Cartographer** | A soul who tried the Crucible once, reached Floor 12, and decided to map it instead of climbing it. Has been charting the tower's procedural patterns ever since, looking for structure in the chaos. | Methodical, dry-witted. Believes the Crucible can be understood through data. Slightly envious of the player's continued attempts. Provides zone lore as "field notes." |
| **The Merchant Prince** | An echo who has figured out how to trade in the liminal economy. Doesn't care about the Crucible's purpose — sees the whole thing as a market opportunity. Collects Echoes and Essence from the residue of failed runs. | Charming, transactional, morally neutral. Will sell the player anything that exists in this space, for a price. Occasionally lets slip that they don't believe the Mold process will work. |
| **The Archivist** | The oldest echo in the Bastion. Claims to have memories of the old world's final days. Collects Lore Tablets not for knowledge but for *preservation* — terrified that if the old world isn't remembered, the new one will repeat its mistakes. | Somber, urgent, obsessed with recording. Treats every Lore Tablet like a sacred artifact. Grows increasingly disturbed by certain tablets' contents. Has a secret theory about why the old world expired that they'll only share after all tablets are found. |
| **The Challenger** | An echo who wanted to be the Mold but was deemed "too aggressive." Now channels their frustration into designing challenges. They don't resent the player — they resent the Primordials for rejecting them. | Competitive, brash, secretly supportive. Their challenges are hard because they genuinely want the player to be strong enough to succeed where they couldn't. Respects skill above all else. |
| **The Wanderer** | Appears only after the first tower clear. An echo who *did* reach the summit once — in a previous cycle, before the current player was chosen. What they found there changed them. They won't say what the summit holds, but they'll help the player prepare for it. | Cryptic, weary, quietly terrified. Speaks in half-truths. Their modifier system ("make it harder") is not a game mechanic to them — it's training. They know something about the Apex that the other NPCs don't. |

### 1B.7 The Lore Tablet Narrative

Lore Tablets are scattered through the Crucible — fragments of the old world's history, preserved in stone by the Primordials. They tell a story across 25 tablets (one per floor, though the player won't find them all in a single run). The tablets are found in random order, and the Archivist helps the player piece them together.

**The Lore Tablet Story Arc (in chronological order, NOT discovery order):**

| Tablet # | Title | Content Summary |
|----------|-------|----------------|
| 1 | "In The Beginning" | The old world's creation. Six forces in balance. Life emerges slowly, over eons. The Primordials do not intervene — they observe. |
| 2 | "The First Spark" | Fire appears. Volcanic world. Life is thermal — organisms that feed on heat. Pyraxis speaks of pride. |
| 3 | "The First Rain" | Water arrives. Oceans form. Life migrates from thermal vents to the sea. Thalassa describes the joy of watching adaptation. |
| 4 | "The First Wind" | Atmosphere develops. Creatures leave the water. Ouranos revels in the first thing to fly — a simple spore carried by a breeze. |
| 5 | "The First Root" | Soil forms. Plants. Forests. Lithara speaks of patience — it took a billion years, but the wait was worth it. |
| 6 | "The First Dawn" | A star stabilizes. Consistent light. Photosynthesis. Solenne describes the old world's sun as "my finest work." |
| 7 | "The First Shadow" | Night. Predation. The first creature to hide, to hunt from darkness. Nythara speaks without apology — "The light needed opposition." |
| 8 | "The Flowering" | Complex life explodes. Millions of species. The Primordials are pleased. Everything is in balance. |
| 9 | "The Thinking Ones" | Sapient life emerges. The Primordials are surprised — they didn't plan this. Debate begins: is this good? |
| 10 | "The Builders" | Civilization. Cities. Language. Art. The Primordials are divided — Solenne and Ouranos are delighted. Lithara is cautious. Nythara is watchful. |
| 11 | "The Harnessing" | The sapient species learns to control the elements. Fire is tamed. Water is channeled. The Primordials feel something they haven't before: they are being *used*. |
| 12 | "The Imbalance" | One element begins to dominate. (Which one is never specified — it changes based on the player's most-used element, making it personal.) The world tilts. The other Primordials notice. |
| 13 | "The Warning" | The Primordials attempt to communicate with the sapient species through natural disasters, visions, dreams. They are ignored. Pyraxis grows angry. Thalassa grows sad. |
| 14 | "The Sickness" | The world is visibly unwell. Ecosystems collapse. Species die. The imbalance accelerates. Lithara speaks of roots rotting underground where no one looks. |
| 15 | "The Argument" | The Primordials argue for the first time since creation. Should they intervene? They have never directly interfered with the world they made. Solenne insists on patience. Nythara disagrees. |
| 16 | "The Intervention" | One Primordial acts alone. (Which one depends on the player's least-used element — the one that felt most marginalized.) It doesn't work. The imbalance is too deep. |
| 17 | "The Cascade" | The world begins to unravel. Not an explosion — a fraying. Edges of reality become thin. The Primordials realize this isn't fixable. |
| 18 | "The Acceptance" | The Primordials stop fighting it. They begin planning for what comes after. The concept of the Mold is proposed — by whom is unclear, and they disagree on who suggested it first. |
| 19 | "The Gathering" | Trillions of souls. The Primordials examine every one. Most are too specialized, too attached to the old world's forms. They need a soul that is *blank* — one with no fixed identity. |
| 20 | "The Selection" | The player is chosen. Why? Each Primordial gives a different reason in their private annotations. Pyraxis: "This one has fire." Thalassa: "This one bends." Lithara: "This one endures." The real answer may be that there is no special reason — they simply needed someone willing. |
| 21 | "The Unmaking" | The old world ends. Not with a bang, not with a whimper — with a sigh. A gentle folding inward. The Primordials preserve what they can: the elements, the potential, the chosen soul. Everything else becomes raw material. |
| 22 | "The Crucible's Purpose" | The Primordials explain the tower's design. It is not a test of worthiness — it is a *kiln*. The soul is the clay. The elements are the glaze. The Crucible is the fire that hardens the clay into its final shape. |
| 23 | "The Other Candidates" | There were others before the player. The Keeper. The Challenger. Others whose echoes have faded. None completed the Crucible. The tablet asks: is this because the task is impossible, or because no one has been the right shape? |
| 24 | "The Wanderer's Testimony" | The Wanderer's account of reaching the summit in a previous cycle. Fragmented. Terrified. "I saw what the new world would be if I was the Mold. I saw a world in my image. I couldn't bear it." This is why the Wanderer stepped down. |
| 25 | "The Final Question" | Found only on Floor 25 (guaranteed placement in the boss room antechamber). The tablet is blank except for one line: *"What will you become?"* |

**Tablet 12 and 16 — Personalization:** These two tablets are dynamically written based on the player's save data. Tablet 12 references the player's most-used element as "the one that consumed the old world." Tablet 16 references the least-used element as "the one that tried to save it." This makes the lore personal — the player's playstyle retroactively shaped the story of the old world's demise.

### 1B.8 The Convergence (Floor 25 Boss) — Narrative Context

The final boss — **The Convergence** — is not a monster. It is a **mirror**. The Convergence is a construct built by the Primordials from every form the player has taken across all their runs. It uses the player's most-used element against them (already specified in §5.3) because it IS the player — or rather, it is the aggregate of every version of the player that failed.

When the player defeats The Convergence, they are not destroying an enemy. They are proving that their current form — the one they've built during this run — is superior to everything they've been before.

**Post-defeat, pre-summit:**

After The Convergence falls, the player enters the final room. No enemies. No hazards. A simple circular chamber with six alcoves — one per Primordial. Each Primordial speaks a single line, acknowledging the player's form:

- **If creature form:** The corresponding Primordial(s) speak approvingly. Others speak with acceptance.
- **If balanced human:** All six speak simultaneously, their voices overlapping into harmony.
- **If Blank Canvas (secret stick figure ultimate):** Stunned silence. Then, quietly, all six: *"You are... nothing. And nothing is everything. We did not expect this."*

The screen fades. The Run Summary appears. The new world is born. The player's creature form at the moment of victory is the Mold.

### 1B.9 The Narrative Arc Across Meta-Progression

The story doesn't just live in Lore Tablets. The tone of the entire game shifts subtly as the player progresses through meta-milestones:

| Milestone | Narrative Shift |
|-----------|----------------|
| **First 5 runs** | The Keeper is the only voice. Tone is instructional, warm, slightly urgent. The world feels empty and unfinished — Bastion is a bare slab. |
| **First boss kill** | The Primordials begin to take notice. Subtle ambient voice lines ("interesting..." / "not yet..." / "again.") are heard faintly during runs, especially near Element Shrines. |
| **Floor 10 reached** | The Cartographer and Alchemist appear. The Bastion starts to feel like a place rather than a waiting room. Lore Tablets begin revealing the old world's history. |
| **Floor 15 reached** | The Merchant Prince and Archivist appear. The Archivist's urgency introduces a darker tone — the old world's collapse was not random. The Primordials' ambient voice lines become more distinct and personal. |
| **Floor 20 reached** | The Challenger appears. The tone shifts to preparation — something is waiting at the top, and the NPCs who know about it are worried. The Keeper becomes quieter, more contemplative. |
| **First tower clear** | The Wanderer appears. The triumphant tone is undercut by the Wanderer's fear. The player succeeded, but the Wanderer's testimony (Tablet 24) raises the question: should they have? The New Game+ modifiers are framed as "preparing for the truth." |
| **All 25 Lore Tablets found** | The Archivist reveals their theory: the old world didn't expire naturally. It was *consumed* — by the same process that is now building the new one. The Primordials are not creators. They are *recyclers*. This has happened before. It will happen again. The player is not the first Mold. They're the latest. |
| **Post-clear with all modifiers active** | The hardest run possible. If completed, a secret final Lore Tablet (26) appears in the Bastion, written by a Mold from a cycle so far back that even the Primordials don't remember it. It says simply: *"I was you. The world I built was beautiful. It expired anyway. Build yours anyway."* |

### 1B.10 Tone and Thematic Guidelines

**The overall tone is:** Melancholy hope. The old world is gone and it mattered, but the new world is being born and it will matter too. Loss and creation are the same process.

**The game should NOT:**
- Moralize about which element or creature form is "correct"
- Frame any Primordial as a villain (they are forces, not people)
- Make the player feel guilty for any build choice
- Explain everything — mystery is a resource, not a deficit
- Make the Lore Tablets mandatory reading. Players who skip them should still enjoy the game. Players who read them should feel rewarded with depth, not burdened with exposition.

**The game SHOULD:**
- Make the player's build choices feel meaningful beyond mechanics
- Create moments of quiet awe between the combat intensity (the Primordials' voice lines, the post-boss chambers, the Bastion growing over time)
- Reward curiosity (Tablet 12/16 personalization, Blank Canvas secret ending, Tablet 26)
- Let the player project their own meaning onto the narrative without the game telling them what to feel

---

### 2.1 The Stick Figure (Base State)

Every run begins with the same character:
- Simple black stick figure rendered with line art (2-3 pixel width lines)
- Proportions: ~32px wide, ~64px tall at default zoom (adjust for final art scale)
- Idle animation: subtle breathing (torso line oscillates ±1px)
- No color, no detail, no clothing, no features beyond the stick figure silhouette
- Base moveset only: light attack (punch/kick), dodge roll, jump

### 2.2 Visual Evolution System

As the player acquires elemental abilities, the character model transforms progressively through **5 visual tiers**:

| Tier | Trigger | Visual Change |
|------|---------|---------------|
| 0 - Blank | Run start | Pure stick figure. Black lines, white/transparent fill. |
| 1 - Sketch | First element acquired | Lines thicken. Faint color wash appears matching element. Simple hands/feet shapes emerge. Body proportions begin hinting at the creature form (see §2.3). |
| 2 - Draft | 2–3 elements or first chain combo | Body fills in with color gradients. Creature silhouette becomes recognizable — limbs reshape, head form changes. Element-specific features emerge (wings bud, horns appear, tail forms, etc.). |
| 3 - Rendered | 4–5 elements or second-tier chain combo | Full creature form realized. Detailed features, textures, and anatomy. Particle effects trail the character. Weapon or focus object manifests. The creature is clearly identifiable (a player can look at the character and say "that's a Phoenix" or "that's a Naga"). |
| 4 - Ascended | 6+ elements or third-tier chain combo | Maximum visual complexity. Aura effects, environmental distortion. Creature form at its most majestic/terrifying. Animation set becomes creature-specific (a Dragon idles differently than an Angel). The visual apex of the build. |

**Critical Implementation Rule:** Visual tier is determined by the *number and depth of elemental combinations*, not by floor number. A player who avoids picking up elements stays closer to stick figure. A player who aggressively combines reaches Tier 4 earlier.

### 2.3 Creature Form System

The player character's **physical form** is determined by the elemental weight of their current build. This is the core visual identity system — two players with different element loadouts won't just have different colors, they'll be different *creatures*.

**The Spectrum Principle:**
- A **perfectly balanced** build across multiple elements produces a **human form** — armored, detailed, but recognizably human. This is the "default" high-tier appearance.
- A build **heavily weighted** toward one or two elements produces a **mythological creature** associated with those elements.
- The creature form is continuous, not binary. A build that's 70% Fire and 30% Air will be a Phoenix with some extra flame features. A build that's 50% Fire and 50% Air will be a cleaner Phoenix. A build that's 40% Fire, 30% Air, 30% Earth will lean Phoenix but with some earthy/grounded features.

**Elemental Weight Calculation:**
Each element in the player's current loadout contributes weight. Combined elements contribute weight to their constituent base elements:
- Base element: 1.0 weight to its type
- Tier 1 combo: 0.6 weight to each parent element
- Tier 2 combo: 0.4 weight to each base element in its chain
- Tier 3 combo: 0.3 weight to each base element in its chain

The weights are normalized to percentages. If one or two elements exceed **50% combined weight**, the creature form activates. Below that threshold, the form trends human.

#### 2.3.1 Single-Element Dominant Forms

When one element represents **50%+ of total weight**, the character becomes a creature associated with that element:

| Dominant Element | Creature Form | Visual Description |
|-----------------|---------------|-------------------|
| **Fire** | **Efreet** | Towering muscular frame wreathed in flame. Skin like cooling magma — black with glowing orange cracks. Horns of solidified fire. Eyes are molten gold. At Tier 4: lower body dissolves into a fire vortex (hovers). |
| **Water** | **Leviathan-kin** | Sleek aquatic humanoid. Blue-green scaled skin, webbed fingers, fins along forearms and calves. Face becomes angular with gill slits. At Tier 4: tentacle-like water appendages trail from the back, octopus-like. |
| **Air** | **Zephyr** | Lithe, elongated frame. Skin becomes semi-transparent with visible wind currents beneath. Hair streams upward perpetually. Feathered forearms. At Tier 4: full wings manifest (eagle-like), feet leave the ground (permanent hover). |
| **Earth** | **Golem** | Broad, heavy frame. Skin becomes stone/bark-textured. Mossy patches, crystal growths on shoulders and back. Face becomes a carved stone mask. At Tier 4: massive — character sprite grows ~20% larger, ground cracks beneath footsteps. |
| **Light** | **Seraph** | Radiant humanoid. Skin glows from within, golden-white. Eyes become pure light. Geometric halo forms behind the head. At Tier 4: six wings (two covering eyes, two covering feet, two spread — biblical angel), body becomes hard to look at directly (bloom effect). |
| **Dark** | **Wraith** | Gaunt, elongated silhouette. Body becomes semi-incorporeal — edges dissolve into shadow. Eyes are the only solid feature (glowing purple/red). Cloak-like darkness flows from shoulders. At Tier 4: lower body is fully shadow, face is a void with floating eyes, tendrils of darkness reach out toward nearby enemies. |

#### 2.3.2 Dual-Element Creature Forms

When two elements together represent **50%+ of total weight** and neither is overwhelmingly dominant (no single element above 60%), the character becomes a creature born from the combination:

| Element Pair | Creature Form | Visual Description |
|-------------|---------------|-------------------|
| **Fire + Air** | **Phoenix** | Bird-of-prey humanoid. Feathered arms that trail fire, crest of flame-feathers on head. Taloned feet. Wings of fire and wind. At Tier 4: full phoenix silhouette — the character IS a bird of fire in humanoid stance. |
| **Fire + Earth** | **Salamander** | Reptilian, low-slung powerful frame. Armored scales of cooling magma over stone. Thick tail for balance. Volcanic vents on shoulders that vent smoke. At Tier 4: quadrupedal option — can sprint on all fours, magma drips from jaw. |
| **Fire + Water** | **Djinn** | Ethereal, smoke-bodied. Upper body is solid and muscular, lower body dissolves into steam. Ornate, vaguely Middle Eastern aesthetic — curved horns, pointed ears. At Tier 4: body shifts between solid and vapor fluidly, leaving steam afterimages. |
| **Fire + Light** | **Solar Dragon** | Draconic humanoid radiating heat and light. Golden scales, crown of solar flares. Wings that glow like stained glass. At Tier 4: body becomes almost too bright — a dragon-shaped sun. Lens flare on every movement. |
| **Fire + Dark** | **Balrog** | Massive, demonic frame. Black skin cracked with hellfire veins. Horns, cloven hooves, whip-like tail of dark flame. Wings of shadow and fire. At Tier 4: wreathed in shadow-flame that obscures exact form — a silhouette of menace with burning eyes. |
| **Water + Air** | **Storm Serpent** | Serpentine humanoid. Elongated, sinuous frame. Scales that shimmer between blue and silver. Lightning arcs between fin-like crests. At Tier 4: lower body becomes a coiling water-spout, hair is a living thundercloud. |
| **Water + Earth** | **Naga** | Snake-bodied from waist down. Upper body is scaled and powerful. Cobra-like hood frames the face. Mud and water swirl around the tail. At Tier 4: massive coils, crushing presence, swamp vegetation grows from the body. |
| **Water + Light** | **Nereid** | Graceful aquatic form with bioluminescent features. Translucent skin revealing light flowing like blood. Coral-like growths form a crown. At Tier 4: ethereal, appears to be made of illuminated water — a living tide pool of light. |
| **Water + Dark** | **Kraken** | Deep-sea horror. Dark blue-black skin, bioluminescent lures. Multiple tentacle-like appendages from the back. Sunken, angular face with too-large eyes. At Tier 4: body becomes an abyss — looking at the character feels like looking into deep water. Tentacles move independently. |
| **Air + Earth** | **Griffin** | Avian-feline hybrid. Eagle head and feathered arms, lion-like lower body. Stone-colored feathers, crystalline talons. At Tier 4: full majestic griffin — massive wingspan, mane of stone-colored feathers, regal bearing. |
| **Air + Light** | **Angel** | Classical angelic form. Luminous skin, white feathered wings, flowing robes of condensed light. Androgynous, serene face. At Tier 4: multiple wing pairs, halo intensifies, body becomes partially transparent — more spirit than flesh. |
| **Air + Dark** | **Banshee** | Gaunt, floating figure. Tattered wind-wraith — darkness streams from the body like torn cloth in a gale. Mouth is a void that screams silently. Hair whips in impossible wind. At Tier 4: barely corporeal, a howling shadow in humanoid shape, wind distortion warps the air around it. |
| **Earth + Light** | **Treant** | Living tree humanoid. Bark skin, branch-like limbs, leaves that glow with inner light. Crystal growths along the grain of the wood. At Tier 4: massive and ancient — a walking sacred grove. Flowers bloom in footsteps, golden sap glows in veins. |
| **Earth + Dark** | **Lich** | Skeletal/gaunt frame wrapped in stone armor. Eye sockets glow with dark energy. Crown of petrified bone. Earth and death intertwined. At Tier 4: an undead king — tattered cape of shadow, throne-like stone growths on the back, ground decays beneath each step. |
| **Light + Dark** | **Eclipse Knight** | Split down the middle — one half radiant, one half shadow. The two halves shift and compete, light and dark rippling across the body. At Tier 4: the division becomes dynamic — the character pulses between fully light and fully dark forms, never settling. |

#### 2.3.3 Derived Element Creature Forms (Combo-Specific Overrides)

The dual-element forms in §2.3.2 represent the *default* for a given elemental weight pair. However, when the player holds a **specific named combination** (not just the base element weights), that combination can **override** the default form with a more specific creature. This is how the truly unusual forms emerge.

**Override Rule:** If the player's highest-tier held element is a specific Tier 1 or Tier 2 combination, AND that combination has a defined creature form, it takes priority over the generic dual-element form. If the player holds multiple combinations, the highest-tier one wins. Ties go to the most recently acquired.

**Tier 1 Combination Creature Overrides:**

| Combination | Default Override From | Creature Form | Visual Description |
|------------|----------------------|---------------|-------------------|
| **Steam** (Fire+Water) | Djinn | **Djinn** | (No override — keeps default dual-element form) |
| **Lightning** (Fire+Air) | Phoenix | **Thunderbird** | Avian form like Phoenix but darker — storm-grey feathers crackling with electricity. Jagged lightning-bolt wing shapes. Eyes are arc-bright. At Tier 4: a living storm in bird form, body barely solid between lightning strikes. |
| **Magma** (Fire+Earth) | Salamander | **Salamander** | (No override — keeps default) |
| **Solar** (Fire+Light) | Solar Dragon | **Solar Dragon** | (No override — keeps default) |
| **Hellfire** (Fire+Dark) | Balrog | **Balrog** | (No override — keeps default) |
| **Ice** (Water+Air) | Storm Serpent | **Wendigo** | Gaunt, antlered humanoid. Pale blue-white skin stretched over angular bones. Too-long arms ending in clawed ice fingers. Frost breath visible on every exhale. Antlers grow larger with tier — at Tier 4: massive rack of ice antlers, body semi-transparent like a glacier, moves with unsettling jerky animation. |
| **Mud** (Water+Earth) | Naga | **Ooze** | Amorphous blob-creature. The character loses defined limbs — arms and legs are pseudopods that extend and retract fluidly. Body is translucent, showing absorbed debris (rocks, bones, gear) floating inside. Moves by flowing across the ground rather than walking. At Tier 4: massive, filling nearly the visual space of the hitbox, semi-transparent with visible internal currents, absorbs visual elements of defeated enemies temporarily (bones, armor fragments float inside). The "blob" — deeply unsettling and deeply satisfying. |
| **Purify** (Water+Light) | Nereid | **Nereid** | (No override — keeps default) |
| **Poison** (Water+Dark) | Kraken | **Arachnid** | Eight-legged horror. Upper body is humanoid but with compound eyes and mandibles. Lower body is a spider's thorax and eight articulated legs. Webs of dark energy trail from the legs. At Tier 4: full spider — massive, low-slung, fangs dripping with venom, web-spinner on the abdomen creates visible poison threads. Legs tap independently during idle. Moves with skittering animation that feels fundamentally different from walking. |
| **Sand** (Air+Earth) | Griffin | **Centaur** | Four-legged form. Human upper body on an equine lower body, but sand-textured — skin has a shifting desert-grain appearance, mane is a cascade of fine sand. Hooves leave sand-blast impacts. At Tier 4: massive and powerful, sandstorm perpetually swirling around the legs, upper body armored in petrified sand-glass plates. The charging run animation has real weight — you feel the four legs driving forward. |
| **Holy Wind** (Air+Light) | Angel | **Angel** | (No override — keeps default, since Air+Light already produces Angel) |
| **Void** (Air+Dark) | Banshee | **Banshee** | (No override — keeps default) |
| **Crystal** (Earth+Light) | Treant | **Treant** | (No override — keeps default) |
| **Decay** (Earth+Dark) | Lich | **Fungal Horror** | Mushroom-bodied humanoid. Torso is a massive fungal cap, limbs are mycelium-wrapped bone. Spore clouds puff with every movement. Face is a cluster of shelf fungi with bioluminescent spots for eyes. At Tier 4: the fungal growth has consumed the entire form — the character is a walking colony, smaller mushrooms sprouting and dying in real-time across the body, spore trail is constant and thick. Disturbingly organic. |
| **Eclipse** (Light+Dark) | Eclipse Knight | **Eclipse Knight** | (No override — keeps default) |

**Tier 2 Combination Creature Overrides:**

Tier 2 combinations can produce even stranger forms. These override everything — if you have a Tier 2 with a defined form, that's what you are.

| Combination | Creature Form | Visual Description |
|------------|---------------|-------------------|
| **Storm** (Lightning+Water) | **Jellyfish** | Floating translucent dome-body with trailing electrical tentacles. The "head" is a pulsing bell-shaped canopy that crackles with internal lightning. Tentacles (4–8 depending on tier) hang below and sway with movement. Moves by pulsing/floating rather than walking — rhythmic contractions of the bell. At Tier 4: massive bell, tentacles reach the ground and arc electricity between them, bioluminescent patterns pulse across the body in storm patterns. Hypnotic and alien. |
| **Magnetic** (Lightning+Earth) | **Living Armor** | A hollow suit of animated armor. No body inside — visible through gaps in the plating is crackling magnetic energy holding the pieces together. Limbs float slightly disconnected, held in formation by electromagnetic force. At Tier 4: ornate full plate that continuously disassembles and reassembles, individual armor pieces orbit the core during attacks, a knight-shaped void that fights by will alone. |
| **Obsidian** (Magma+Water) | **Glass Golem** | Body of volcanic glass — black, reflective, razor-sharp edges. Light refracts through the body creating internal rainbow caustics. Cracks glow with magma underneath. Moves with deliberate, careful precision (glass doesn't bend). At Tier 4: partially shattered and reformed, floating glass shards orbit the body, light splits into prismatic displays, beautiful and dangerous. |
| **Permafrost** (Ice+Earth) | **Mammoth** | Heavy, tusked quadruped form. Shaggy frost-crystal "fur" over stone-hard skin. Massive curved tusks of solid ice. Trunk-like face. At Tier 4: colossal presence, frost radiates outward in visible waves, tusks are crystalline and luminous, each step leaves permafrost footprints that persist briefly. Ancient and unstoppable. |
| **Toxic Fume** (Poison+Fire) | **Slime** | Bubbling, semi-liquid form. Body is a roiling mass of toxic sludge that barely holds humanoid shape. Constantly dripping and reforming. Colors shift between sickly green, chemical yellow, and burnt orange. At Tier 4: the form is barely contained — slime trails on every surface touched, body stretches and snaps back during attacks like a living lava lamp of poison, occasionally "burps" toxic bubbles. Gross. Fun. |
| **Antivenom** (Poison+Light) | **Moth** | Luminous insect humanoid. Large compound eyes reflecting rainbow light. Four gossamer wings with eye-spot patterns that glow. Fuzzy thorax and antenna. At Tier 4: wings are enormous and perpetually spread, eye-spot patterns on the wings pulse with healing light, antenna sense invisible things (subtle glow toward nearby secrets/items). Ethereal, strange, beautiful. |
| **Shadow Crystal** (Crystal+Dark) | **Doppelganger** | An unsettling mirror-version of the stick figure — but wrong. Proportions are slightly off, movements are a half-beat delayed, the face is a smooth reflective surface. At Tier 4: multiple overlapping silhouettes that don't quite sync, like looking at the character through a broken mirror. The most uncanny valley form — players will either love or hate it. |
| **Volcanic Ash** (Magma+Air) | **Ember Wraith** | Skeletal frame made of cooling ash, constantly crumbling and reforming. Each movement sheds ash particles that float upward. The body is a suggestion more than a solid — like a figure made of campfire remains given life. At Tier 4: a towering column of ash in vaguely humanoid shape, perpetual updraft of embers, red glow deep in the chest where a heart would be. |
| **Gravity** (Void+Earth) | **Tardigrade** | Micro-made-macro. Bulbous, segmented body with eight stubby limbs. Translucent skin revealing internal structures. Tiny round mouth. The "water bear" blown up to character scale. At Tier 4: plated and armored, virtually indestructible-looking, moves with ponderous certainty, gravity distortion visible around the body bending light. The weirdest form in the game — and weirdly adorable. |
| **Dimensional** (Void+Light) | **Tesseract** | A geometrically impossible form. The character appears to be a 3D projection of a 4D shape — parts of the body fold in and out of visibility, limbs connect at angles that shouldn't work. Hypercube patterns flicker across the skin. At Tier 4: fully non-euclidean, the character is painful to look at directly (subtle screen distortion effect around the sprite), parts of the body appear to be in multiple places simultaneously. The math nerd's favorite form. |

#### 2.3.4 Form Selection Priority

When determining the player's creature form, the system checks in this order:

1. **Tier 2+ combo-specific override** — If the player holds a Tier 2 or Tier 3 combination with a defined creature form, use it.
2. **Tier 1 combo-specific override** — If the player holds a Tier 1 combination with a defined override, use it.
3. **Dual-element default** (§2.3.2) — Based on the two highest-weighted base elements.
4. **Single-element dominant** (§2.3.1) — If one element exceeds 60% weight.
5. **Balanced human** (§2.3.5) — If no element or pair dominates.

This means a player who combines Mud (Water+Earth) becomes an Ooze, NOT a Naga. But if they then combine Mud with Fire to get Mud Geyser (which has no specific creature override), the form falls back to the dual-element check based on current weights.

#### 2.3.5 Balanced / Multi-Element Human Form

When no element or pair dominates (all weights below 50%), the character trends toward a **human warrior/mage** form. The human form is not generic — it's detailed and reflects all contributing elements through armor, clothing, weapons, and subtle features:

| Balance Level | Visual Description |
|--------------|-------------------|
| **Evenly balanced (3+ elements, none dominant)** | Fully human. Ornate armor/robes incorporating all active element colors. Weapon reflects the highest-weighted element. Face is detailed and expressive. This is the "knight" or "battlemage" archetype. |
| **Slight lean (one element at 35–49%)** | Human with subtle creature traits from the dominant element. A fire-leaning human might have ember-colored eyes and faintly glowing skin. An earth-leaning human might be stockier with stone-like gauntlets that look grown rather than forged. |

**The human form is the rarest at high tiers** — it requires intentional balance across multiple elements, which is harder than focusing. Seeing a Tier 4 human in someone's hub means they're a versatile player who balances their builds carefully.

#### 2.3.6 Body Category Mechanics

Creature forms are **not cosmetic**. Each body category has distinct mechanical properties that meaningfully change how the game plays. Your elemental choices don't just determine your abilities — they determine your body, and your body determines your strengths and weaknesses.

**Design Principle:** Every body category has trade-offs. No category is strictly better than another. A Quadruped hits harder and has more HP but is a bigger target and can't dodge as nimbly. An Avian is fast and evasive but fragile. The player's creature form is a second layer of build strategy on top of their element/ability choices.

| Body Category | Forms | Move Speed | Hitbox | HP Modifier | Dodge | Passive |
|--------------|-------|-----------|--------|------------|-------|---------|
| **Bipedal** | Human, Efreet, Seraph, Wraith, Balrog, Eclipse Knight, Angel, Nereid, Treant, Lich, Fungal Horror | 150 (base) | Medium (radius 10px) | +0% | Standard roll (0.2s i-frames, 0.5s cooldown) | **Adaptable** — No strengths, no weaknesses. All ability cooldowns reduced by 5%. The jack-of-all-trades. |
| **Quadruped** | Centaur, Salamander, Griffin, Mammoth | 140 (slightly slower) | Large (radius 14px) | +25% | Sidestep leap (0.15s i-frames, 0.7s cooldown, covers more distance) | **Trample** — Running through Fodder-category enemies deals 5 damage and staggers them. Melee attacks have +15% knockback. |
| **Serpentine** | Naga, Storm Serpent | 155 (slightly faster) | Long/narrow (ellipse 8×16px) | +0% | Coil-spring (0.25s i-frames, 0.4s cooldown, shorter distance) | **Constrict** — Melee attacks on Entangled enemies deal +30% damage. Immune to Entangled status. |
| **Arachnid** | Arachnid | 170 (fast) | Medium (radius 10px) | -10% | Lateral scuttle (0.2s i-frames, 0.35s cooldown, can change direction mid-dodge) | **Web Sense** — Enemies within 5 tiles are revealed on the minimap even through walls. Ambush attacks (attacking an unaware enemy) deal +25% damage. |
| **Avian** | Phoenix, Thunderbird, Zephyr | 165 (fast) | Small (radius 8px) | -15% | Barrel roll (0.25s i-frames, 0.4s cooldown, gains brief height — immune to ground hazards for 0.5s after dodge) | **Airborne** — Immune to ground hazards (lava, spikes, mud, puddles) while moving. Standing still for 1.5s removes this immunity until movement resumes. Ranged abilities have +10% range. |
| **Amorphous** | Ooze, Slime | 130 (slow) | Large (radius 14px) | +20% | Splat-reform (0.3s i-frames, 0.6s cooldown, leaves damaging residue at dodge origin — 8 damage to enemies who touch it) | **Absorption** — 15% of all damage taken is converted to Essence instead of HP loss. Physical (non-elemental) damage is reduced by 20%. Status effect durations on the player are halved. |
| **Floating** | Djinn, Jellyfish, Banshee, Ember Wraith | 145 (slightly below base) | Small (radius 8px) | -5% | Phase shift (0.3s i-frames, 0.5s cooldown, passes through enemies and terrain during dodge) | **Hover** — Permanently immune to ground hazards. Cannot be Entangled. Projectile abilities pass through destructible terrain. |
| **Arthropod** | Tardigrade | 120 (slowest) | Medium (radius 12px) | +40% | Tuck-roll (0.35s i-frames — longest in game, 0.8s cooldown, curls into armored ball that reflects projectiles during i-frames) | **Endurance** — Cannot be knocked back. Cannot be stunned for more than 0.5s (stun duration capped). Regenerates 1 HP/s passively. |
| **Geometric** | Living Armor, Glass Golem, Doppelganger, Tesseract | 140 | Medium (radius 10px) | +10% | Disassemble (0.2s i-frames, 0.5s cooldown, body breaks apart and reforms — AoE damage at both origin and destination, 10 damage each) | **Construct** — Immune to Poison and Burning. Takes +25% damage from Earth element attacks (shattering). Ability damage +10%. |
| **Insectoid** | Moth | 160 (fast) | Small (radius 7px — smallest) | -20% | Vertical lift (0.2s i-frames, 0.3s cooldown — fastest dodge cooldown in game, very short distance) | **Flutter** — Dodge cooldown is 40% shorter than other categories. Stamina cost for dodge reduced by 50%. When below 30% HP, movement speed increases by 20% (flight response). Fragile but incredibly evasive. |

**Critical Design Notes:**
- HP modifier applies to the player's max HP. A player with 100 base HP in Arthropod form has 140 max HP. If they transition to Avian form mid-run, their max HP drops to 85 and current HP is capped to the new max (excess HP is lost, not stored).
- Hitbox size directly affects how easy the player is to hit. A Small hitbox Moth can weave through projectile patterns that would shred a Large hitbox Mammoth.
- Passive abilities activate immediately on form transition and deactivate when the form changes.
- The **Human/Bipedal** form is the baseline — no bonuses, no penalties, just the 5% cooldown reduction as reward for the difficulty of maintaining balance.

**Audio Rule:** Each body category has its own **footstep/movement sound set**. The Ooze squelches. The Arachnid clicks. The Living Armor clanks. The Mammoth thuds. Players should be able to identify their form by sound alone.

#### 2.3.7 Creature Transition Rules

- **Creature form is recalculated** every time an element is acquired, combined, or dropped. The transition between forms should be smooth (1–2 second morph animation), not a hard cut.
- **Mid-run form changes are expected and strategically significant.** A player might start as a Fire-dominant Efreet (Bipedal, balanced stats), combine with Air to become a Phoenix (Avian, fast/evasive/fragile), then pick up Earth to shift toward a Centaur (Quadruped, tanky/powerful). Each transition changes their mechanical profile — gaining HP might save them, or losing dodge agility might kill them. This is a core strategic consideration when choosing elements.
- **HP on transition:** When max HP changes due to form transition, current HP is adjusted proportionally. If you're at 50% HP as a Bipedal (50/100) and transition to Arthropod (+40%), your new HP is 70/140 (still 50%). You don't gain or lose health percentage — you gain or lose the buffer.
- **Hitbox transitions are instant** even though the visual morph is gradual. The gameplay hitbox snaps to the new size the moment the form change is calculated to avoid exploits.

#### 2.3.8 Color and Particle Rules

Each element still contributes color and particle effects on top of the creature form:

| Element | Color Palette | Particle Effect |
|---------|--------------|-----------------|
| Fire | Orange, red, yellow | Sparks, small flames trailing movement |
| Water | Blue, teal, white | Droplets, mist, ripple rings on ground |
| Air | White, pale blue, silver | Wind lines, leaf-like swirls |
| Earth | Brown, green, grey | Pebbles, dust clouds on footsteps |
| Light | Gold, white, pale yellow | Lens flares, radiant pulses |
| Dark | Purple, black, deep blue | Shadow wisps, darkness tendrils |

These particles overlay the creature form. A Fire+Earth Salamander has both ember sparks AND dust clouds. A balanced human has subtle mixed particles from all contributing elements.

---

## 3. ELEMENTAL ALCHEMY SYSTEM

### 3.1 Base Elements (6)

These are the foundational elements. The player starts each run with access only to elements they have **unlocked via meta-progression**. On the very first run, only **Fire and Water** are available.

| ID | Element | Unlock Condition |
|----|---------|-----------------|
| `FIRE` | Fire | Available from first run |
| `WATER` | Water | Available from first run |
| `AIR` | Air | Defeat Floor 5 boss for the first time |
| `EARTH` | Earth | Defeat Floor 5 boss for the first time |
| `LIGHT` | Light | Defeat Floor 15 boss for the first time |
| `DARK` | Dark | Defeat Floor 15 boss for the first time |

### 3.2 Combination System — Chain Alchemy

Elements combine in a tiered chain system. Each combination produces a **derived element** with its own abilities and visual identity.

**Tier 1 Combinations (Base + Base):**

| Input A | Input B | Result | Combat Identity |
|---------|---------|--------|----------------|
| Fire | Water | **Steam** | AoE cloud damage, obscures vision, pressure-based knockback |
| Fire | Air | **Lightning** | Fast projectiles, chain damage between nearby enemies, stun |
| Fire | Earth | **Magma** | Slow-moving ground hazards, high damage, area denial |
| Fire | Light | **Solar** | Radiant beam attacks, burn + blind, long range |
| Fire | Dark | **Hellfire** | Cursed flames that ignore armor, damage over time, lifesteal |
| Water | Air | **Ice** | Freeze/slow effects, brittle shatter combos, defensive walls |
| Water | Earth | **Mud** | Slow traps, entangle, pulled/redirected enemy movement |
| Water | Light | **Purify** | Healing abilities, cleanse debuffs, bonus damage to corrupted enemies |
| Water | Dark | **Poison** | Damage over time stacking, weakening debuffs, cloud hazards |
| Air | Earth | **Sand** | Blinding storms, erosion damage (armor shred), evasion buff |
| Air | Light | **Holy Wind** | Homing projectiles, displacement, speed boost aura |
| Air | Dark | **Void** | Teleport, gravity wells, pull enemies together |
| Earth | Light | **Crystal** | Reflective shields, piercing projectiles, terrain creation |
| Earth | Dark | **Decay** | Weaken structures/armor, corpse explosion, summon from dead |
| Light | Dark | **Eclipse** | Phase shifting (brief invulnerability), balanced damage/defense, both buff and debuff |

**Tier 2 Combinations (Tier 1 + Base OR Tier 1 + Tier 1):**

| Input A | Input B | Result | Combat Identity |
|---------|---------|--------|----------------|
| Steam | Earth | **Mud Geyser** | Erupting ground attacks, knockup + slow, area control |
| Steam | Fire | **Superheated** | Extreme burn damage, explosion on contact, self-damage risk |
| Lightning | Water | **Storm** | Large AoE, chain lightning through water puddles, weather control |
| Lightning | Earth | **Magnetic** | Pull/push metal enemies, redirect projectiles, shield generator |
| Magma | Water | **Obsidian** | Extremely hard projectiles, shatter on impact AoE, armor generation |
| Magma | Air | **Volcanic Ash** | Persistent AoE blind + choke, fire damage in cloud, wind-directed |
| Ice | Fire | **Thermal Shock** | Rapid freeze-then-burn, shatter bonus damage, elemental vulnerability |
| Ice | Earth | **Permafrost** | Permanent terrain modification, trap creation, defensive fortress |
| Poison | Fire | **Toxic Fume** | Ignitable gas clouds, massive AoE burst potential, risky |
| Poison | Light | **Antivenom** | Convert poison stacks to healing, poison immunity aura, purge |
| Crystal | Dark | **Shadow Crystal** | Stealth + reflection, create decoy illusions, ambush damage bonus |
| Crystal | Fire | **Prism** | Split projectiles into multiple beams, rainbow damage types, spectacular visual |
| Void | Light | **Dimensional** | Portal creation, redirect attacks, spatial manipulation |
| Void | Earth | **Gravity** | Crush zones, levitate enemies, weight manipulation |
| Eclipse | Fire | **Supernova** | Massive delayed AoE, charges over time, catastrophic damage |
| Eclipse | Water | **Tidal Force** | Rhythmic push/pull waves, timing-based combat, lunar cycle buff |

**Tier 3 Combinations (Tier 2 + any):**

Tier 3 produces **Ultimate Elements**. Only one Tier 3 element can be active at a time per character. These are the pinnacle builds.

| Input A | Input B | Result | Combat Identity |
|---------|---------|--------|----------------|
| Storm | Magma | **Cataclysm** | Screen-wide destruction, environmental transformation, godlike power with high self-damage risk |
| Permafrost | Hellfire | **Entropy** | Dual hot/cold aura, enemies near you take constant damage, freezing and burning simultaneously |
| Dimensional | Crystal | **Architect** | Reshape the arena, create walls/platforms/traps at will, total spatial control |
| Gravity | Storm | **Maelstrom** | Persistent vortex companion, pulls enemies and projectiles, grows by absorbing damage |
| Supernova | Void | **Singularity** | Charges to critical mass, detonates for near-total room clear, long cooldown, leaves player vulnerable during charge |
| Prism | Holy Wind | **Aurora** | Homing prismatic projectiles that heal allies and damage enemies, visual spectacle, the "beautiful" build |
| Tidal Force | Permafrost | **Absolute Zero** | Total freeze in radius, shatter for massive damage, cooldown-gated but nearly unstoppable |

### 3.3 How Elements Are Acquired

Elements are **not** found in the player's inventory. They are **permanent modifications to the character for the duration of the run.**

**Acquisition Methods:**
1. **Element Shrines:** Found in cleared rooms. Offer a choice of 2–3 available base elements. The player picks one. Frequency: approximately 1 shrine per 2 floors.
2. **Combination Altars:** Found in special rooms. If the player has two elements that can combine, the altar offers the combination. The player can accept or decline. Accepting replaces the two input elements with the combined result. Frequency: 1 altar guaranteed per 3 floors, with random chance of additional altars.
3. **Boss Drops:** Each boss has an elemental affinity. Defeating a boss always drops their element (or a combination ingredient). This is the primary reliable source.
4. **Rare Drops:** Elite enemies have a small chance (5–10%) to drop an element shard. Collecting 3 shards of the same element grants that element.

**Critical Rule — Element Slots:**
- The player can hold a **maximum of 4 active elements** at any time.
- Acquiring a 5th element requires sacrificing one existing element (player chooses which to drop).
- Combined elements count as **1 slot** (Steam occupies 1 slot, not 2).
- This slot limit forces meaningful build decisions and prevents "collect everything" strategies.

### 3.4 Combination Discovery

- On the **first time** a combination is performed in any run, the result is revealed with a discovery animation and the recipe is **permanently recorded** in the Codex (accessible from the hub).
- Undiscovered combinations show as "???" at Combination Altars — the player can gamble on unknown results or stick with known recipes.
- **Meta-progression unlock:** The "Alchemist's Memory" hub upgrade allows the player to see the names (but not full effects) of undiscovered combinations at altars.

---

## 4. COMBAT SYSTEM

### 4.1 Core Mechanics

**Movement:**
- 8-directional movement on an isometric plane
- Base speed: consistent across all builds (no element modifies base walk speed; sprint and dash are separate)
- Sprint: hold button, 50% speed increase, drains stamina
- Dodge roll: i-frames for 0.2 seconds, 0.5 second cooldown, costs stamina

**Stamina:**
- Maximum: 100 (base)
- Regeneration: 15/second (pauses for 1 second after any stamina expenditure)
- Dodge roll cost: 25
- Sprint cost: 10/second
- Some elements modify stamina costs or regen (Air reduces dodge cost by 20%, Earth increases max by 25, etc.)

**Health:**
- Starting HP: 100
- No natural regeneration (must use Purify element, consumable items, or specific room events)
- Maximum HP can be increased through meta-progression (+10 per hub upgrade tier, max +50)
- Damage numbers displayed as floating text

### 4.2 Base Moveset (Stick Figure — No Elements)

| Input | Action | Damage | Speed | Notes |
|-------|--------|--------|-------|-------|
| Light Attack | Quick punch/kick | 8 | 0.3s | 3-hit combo chain: 8, 8, 12 |
| Heavy Attack | Slow overhead strike | 20 | 0.8s | Small AoE on impact, slight knockback |
| Dodge Roll | Invincible dash | 0 | 0.4s duration | 0.2s i-frames, directional |
| Jump | Vertical hop | 0 | 0.5s | Dodge ground hazards, small platforms |

### 4.3 Elemental Ability Slots

When the player acquires elements, abilities are mapped to **4 ability slots** (bound to keys/buttons):

| Slot | Default Binding (KB) | Default Binding (Controller) | Type |
|------|----------------------|------------------------------|------|
| Ability 1 | Q | LB | Primary elemental attack |
| Ability 2 | E | RB | Secondary elemental attack / utility |
| Ability 3 | R | LT | Defensive / movement ability |
| Ability 4 | F | RT | Signature ability (long cooldown, powerful) |
| Ultimate | V (KB) / LB+RB (Controller) | See §4.6 | Ultimate ability (charge-gated, build-defining) |

**Each element grants exactly 4 abilities**, one per slot. When a new element is acquired, its abilities **replace** the current occupants of those slots. Combined elements have unique abilities that are generally stronger than base element abilities.

**Example — Fire:**
- Slot 1: **Fireball** — Projectile, 25 damage, 1.5s cooldown, ignites for 3 damage/s for 3s
- Slot 2: **Flame Wave** — Cone AoE, 15 damage, pushes enemies back, 3s cooldown
- Slot 3: **Ember Dash** — Dash forward leaving fire trail, 2s cooldown, fire trail lasts 4s dealing 5 damage/s
- Slot 4: **Inferno** — Large AoE around player, 60 damage, 15s cooldown, destroys destructible terrain

**Example — Steam (Fire+Water Tier 1):**
- Slot 1: **Steam Blast** — Directional cone, 30 damage, obscures enemy vision for 2s, 2s cooldown
- Slot 2: **Pressure Bomb** — Placed AoE, detonates after 1.5s, 40 damage + knockback, 4s cooldown
- Slot 3: **Vapor Step** — Teleport short distance (become steam briefly), 2.5s cooldown, leaves damaging cloud at origin
- Slot 4: **Boiler Burst** — Massive steam explosion, 80 damage, stuns all enemies for 1.5s, 20s cooldown

### 4.4 Damage Types and Resistances

Every damage instance has an **element tag**. Enemies have resistances and vulnerabilities:

| Resistance Level | Damage Multiplier |
|-----------------|-------------------|
| Immune | 0x |
| Resistant | 0.5x |
| Normal | 1.0x |
| Vulnerable | 1.5x |
| Critical Weakness | 2.0x |

**Status Effects:**
| Status | Source Elements | Effect | Duration | Stacking |
|--------|---------------|--------|----------|----------|
| Burning | Fire, Magma, Hellfire | 3 damage/s | 3s | Refreshes duration, +1 damage/s per stack (max 10 stacks) |
| Frozen | Ice, Water | Movement speed -50%, attack speed -25% | 2s | Does not stack, refreshes |
| Shocked | Lightning, Storm | Next attack taken deals +30% damage | 3s or until triggered | Does not stack |
| Poisoned | Poison, Decay | 2 damage/s, healing received -30% | 5s | Stacks up to 5, each adding damage |
| Blinded | Sand, Volcanic Ash | Enemy accuracy -50%, reduced aggro range | 2s | Refreshes duration |
| Entangled | Mud, Permafrost | Cannot move, can still attack | 1.5s | Does not stack |
| Cursed | Dark, Hellfire | Damage taken +20%, no status immunity | 4s | Refreshes duration |
| Blessed | Light, Purify | Damage dealt +15%, immune to Cursed/Poisoned | 3s | Refreshes duration |

### 4.5 Combo System

Certain status effects interact. Applying a second status to an already-afflicted enemy triggers a **combo reaction**:

| First Status | Second Status | Combo Reaction | Effect |
|-------------|---------------|----------------|--------|
| Frozen | Fire damage | **Shatter** | Freeze ends, 50 bonus damage, AoE chip damage to nearby |
| Burning | Water damage | **Steam Burst** | Both end, AoE knockback + vision obscure |
| Poisoned | Fire damage | **Toxic Ignition** | Poison consumed, AoE explosion based on poison stacks (15 per stack) |
| Shocked | Water damage | **Conduction** | Chain lightning to all wet/nearby enemies, 30 damage each |
| Entangled | Air damage | **Uproot** | Enemy launched airborne (vulnerable to juggle), 20 damage |
| Cursed | Light damage | **Purge** | Curse removed, 40 holy damage, brief stun |
| Blinded | Dark damage | **Terror** | Enemy flees for 3s, takes 10 damage/s while fleeing |

### 4.6 Ultimate Abilities

Ultimates are a **separate system** from the 4 ability slots. Every character has access to one ultimate at a time. Ultimates are build-defining moments — they should make the player feel powerful, reward skillful play, and vary dramatically in how they charge, trigger, and resolve.

**Key Design Principle:** No two ultimate *types* should work the same way. The charge mechanic, activation style, and combat effect all vary based on the specific ultimate. This means the ultimate system is not a single unified meter — it's a framework that supports multiple charge/trigger paradigms.

**Default Input:** V (keyboard), LB+RB simultaneous press (controller). Ultimate is always a deliberate, slightly awkward input to prevent accidental activation.

#### 4.6.1 Ultimate Acquisition

- **Tier 0 (Stick Figure):** No ultimate available. The V key does nothing.
- **Visual Tier 1 (first element):** Unlocks the **base element ultimate** for whichever element the player acquired.
- **Combining elements:** When elements combine at an altar, the ultimate changes to match the new combined element. If the player holds multiple uncombined elements, the ultimate corresponds to the **most recently acquired** element.
- **Tier 3 (Ultimate Elements):** Tier 3 elements have the most powerful ultimates in the game. Reaching Tier 3 replaces whatever ultimate the player had.
- **Only one ultimate active at a time.** It always corresponds to the player's highest-tier element. In case of a tie (e.g., two Tier 1 elements), it defaults to the most recently acquired.

#### 4.6.2 Charge Mechanics

Each ultimate has one of the following charge types. The charge type is intrinsic to that specific ultimate — it cannot be changed.

| Charge Type | How It Works | UI Indicator |
|-------------|-------------|--------------|
| **Damage Dealt** | Meter fills based on damage output. Dealing 300 total damage = full charge. Resets to 0 after use. | Filling circle, glow pulses faster as it approaches full |
| **Damage Taken** | Meter fills based on damage received. Taking 80 total damage = full charge. Rewards aggressive/risky play. | Cracked circle that mends as it fills, red pulse at full |
| **Combo Reactions** | Each combo reaction (Shatter, Conduction, etc.) adds 33% charge. 3 combo reactions = full charge. | Segmented circle (3 segments), each lights up on combo |
| **Kill Streak** | Kill 8 enemies without taking a hit. Taking any damage resets the counter. High risk, high reward. | Stacking kill icons around the circle, all shatter on hit taken |
| **Timed Buildup** | Begins charging automatically when combat starts. Full charge in 45 seconds of active combat (pauses outside combat). | Clock-like sweep animation |
| **HP Threshold** | Available whenever player is below 25% HP. Can be used repeatedly while below threshold, but each use costs 10% of max HP. Desperation mechanic. | Always visible but greyed out; ignites when HP drops below threshold |
| **Elemental Saturation** | Use abilities from your equipped element 20 times (any ability slot). Encourages element mastery. | Counter with element icon, fills like a progress bar |

#### 4.6.3 Activation Types

Each ultimate has one of the following activation styles:

| Activation Type | Description | Player State During |
|-----------------|-------------|-------------------|
| **Instant** | Single massive effect the moment V is pressed. No windup, no vulnerability. Fast and decisive. | Brief animation lock (0.3s), then free |
| **Transformation** | Player enters an altered state for 8–12 seconds. New moveset, enhanced stats, altered appearance. | Full control, enhanced abilities, can still take damage |
| **Channel** | Player stands still and channels for 2–4 seconds. Interruptible by hard CC (stun, knockback). Massive payoff if completed. | Rooted, vulnerable, can be interrupted — but devastating if it lands |
| **Summon** | Creates a persistent entity (elemental construct, zone, companion) that fights alongside the player for 10–15 seconds. | Full control, summon acts autonomously with basic AI |
| **Field** | Creates a large persistent area effect (arena-wide or near-arena-wide) lasting 6–10 seconds. Changes the rules of combat for its duration. | Full control, field affects enemies and environment |
| **Sacrifice** | Consumes something (HP, current element, Essence) in exchange for an overwhelming effect. High cost, high reward. | Varies — some are instant, some are brief channels |

#### 4.6.4 Base Element Ultimates (6)

| Element | Ultimate Name | Charge Type | Activation | Duration | Effect |
|---------|--------------|-------------|------------|----------|--------|
| **Fire** | **Wildfire** | Damage Dealt | Field | 8s | The entire room floor ignites. All ground tiles deal 8 damage/s to enemies standing on them. Fire spreads to enemies, applying max-stack Burning instantly. Player is immune to the fire. The arena becomes a death zone — enemies must constantly move or die. |
| **Water** | **Deluge** | Damage Taken | Summon | 12s | A massive water elemental rises from the ground. It has 200 HP, moves slowly, and body-slams enemies for 35 damage with knockback. Leaves water puddles everywhere it walks (enabling Conduction combos with Lightning). If destroyed early, it explodes into a healing rain that restores 30 player HP. |
| **Air** | **Eye of the Storm** | Timed Buildup | Transformation | 10s | Player becomes a living cyclone. Movement speed +100%, dodge roll replaced with a short-range teleport, all attacks gain knockback, and a persistent wind aura pushes nearby enemies away and deflects projectiles. Light attack becomes a rapid wind slash combo (5 hits/second, 6 damage each). |
| **Earth** | **Tectonic** | Kill Streak | Channel | 3s channel, then instant | Player plants fist into ground (3 second channel, vulnerable). On completion: the entire room shakes, all enemies are stunned for 2 seconds, stone spikes erupt under every enemy dealing 60 damage, and 4 stone pillars rise from the ground as permanent cover objects for the rest of the room. If interrupted, 50% charge is refunded. |
| **Light** | **Judgment** | HP Threshold | Instant | N/A (instant) | A column of searing light strikes every enemy on screen simultaneously. Deals 40 damage + applies Blessed to the player for 10 seconds + fully removes all debuffs from the player. If any enemy is killed by the strike, the player heals 15 HP per kill. Desperation move — available when near death, and the healing reward means it can pull you back from the edge. |
| **Dark** | **Event Horizon** | Combo Reactions | Field | 6s | A sphere of absolute darkness expands from the player to cover 60% of the room. Inside the sphere: all enemies are Blinded and Cursed, enemy projectiles are destroyed on contact with the boundary, the player becomes semi-invisible (enemies lose tracking and attack randomly), and the player's attacks deal +40% damage. Outside the sphere: unaffected. Enemies can flee the sphere but the player can reposition it by moving. |

#### 4.6.5 Tier 1 Combination Ultimates (15)

| Element | Ultimate Name | Charge | Activation | Effect Summary |
|---------|--------------|--------|------------|----------------|
| **Steam** | **Pressure Cooker** | Damage Dealt | Field (8s) | Sealed steam fills the room. Increasing pressure ticks — 5, 10, 15, 20 damage/s escalating each 2 seconds. Player takes half damage from the steam. Enemies that die while pressurized explode, dealing 25 AoE damage to nearby enemies. Chain explosions possible. |
| **Lightning** | **Thundergod** | Kill Streak | Transformation (10s) | Player crackles with electricity. All attacks chain to 2 additional nearby enemies. Movement leaves lightning trails that persist for 3 seconds (15 damage to enemies crossing). Dodge roll is replaced with a lightning bolt teleport that damages enemies at origin and destination (20 damage each). |
| **Magma** | **Eruption** | Elemental Saturation | Channel (2s) | Player channels briefly, then 5 magma geysers erupt at random enemy positions sequentially over 4 seconds. Each geyser deals 50 damage in a medium AoE, launches enemies airborne, and leaves a persistent lava pool (10 damage/s, 8 seconds). Room becomes a lava minefield. |
| **Solar** | **Corona** | Timed Buildup | Transformation (12s) | Player becomes wreathed in solar fire. Constant radiant aura deals 6 damage/s to all enemies within melee range. All abilities have +30% range and apply Burning. Heavy attack becomes a solar beam (line AoE, 45 damage, 1.5s cooldown). At the end of the 12 seconds, a final solar flare pulses outward for 30 damage to all enemies on screen. |
| **Hellfire** | **Damnation** | HP Threshold | Sacrifice | Player sacrifices 40% of current HP. Cursed hellfire chains erupt from the player connecting to every enemy on screen. Each chain deals 10 damage/s for 6 seconds and applies Cursed. Enemies killed while chained explode into more hellfire, potentially chaining to other enemies. The lower the player's HP when activated, the higher the damage multiplier (1.0x at 25% HP, up to 1.5x at 5% HP). |
| **Ice** | **Absolute Still** | Combo Reactions | Instant | Time appears to freeze. All enemies are Frozen for 4 seconds (bypasses stun immunity). All projectiles currently in flight freeze in place and shatter after 4 seconds dealing AoE damage. Player moves at normal speed during the freeze. Every attack on a frozen enemy is an automatic Shatter combo (50 bonus damage). Best combined with fast multi-hit attacks. |
| **Mud** | **Quagmire** | Damage Taken | Field (10s) | The entire floor becomes deep mud. All enemy movement speed reduced by 70%. Enemies that stop moving for 1.5 seconds become Entangled (pulled under). Entangled enemies take 15 damage/s and must be "freed" by allies attacking the mud around them (or they die in 6 seconds). Player walks on top of the mud at normal speed. Ranged enemies can still attack but cannot reposition. |
| **Purify** | **Sanctification** | Damage Taken | Field (10s) | A radiant sanctified zone covers the room. While active: player regenerates 8 HP/s, all player attacks apply Blessed, all poison/curse/burn effects on the player are instantly cleansed and cannot be reapplied, and enemies that die within the zone leave behind a healing orb (restores 10 HP). The ultimate support/sustain tool — turns a losing fight into a war of attrition. |
| **Poison** | **Pandemic** | Elemental Saturation | Summon (15s) | A toxic miasma cloud spawns and drifts toward the nearest enemy. On contact, it applies 5 stacks of Poison instantly and moves to the next enemy. If a Poisoned enemy dies, the cloud splits into two smaller clouds (each applying 3 stacks). Clouds persist for 15 seconds or until no enemies remain. In dense rooms, creates cascading poison chains. |
| **Sand** | **Sandstorm** | Timed Buildup | Field (8s) | Blinding sandstorm fills the room. All enemies are Blinded for the duration. Erosion effect shreds 5% of each enemy's max HP per second (percentage-based — scales against all enemies equally). Player has perfect vision within 3 tiles but limited vision beyond. Enemy ranged attacks are deflected randomly by wind. Excellent equalizer against high-HP enemies. |
| **Holy Wind** | **Rapture** | Kill Streak | Transformation (8s) | Player ascends slightly off the ground (hover, immune to ground hazards). All abilities become homing — projectiles and even melee swings track the nearest enemy. Movement speed +50%. A trailing wind damages enemies for 5 damage/s in the player's wake. At the end, a final gust pushes all enemies to the room's edges and deals 25 damage. |
| **Void** | **Collapse** | Combo Reactions | Channel (2.5s) | Player opens a gravitational singularity at a targeted point. Over the channel duration, all enemies are slowly pulled toward the point (stronger pull the closer they are). On completion: the singularity collapses, dealing damage based on proximity — 80 damage at the center, falling off to 20 at the edges. Enemies that overlap at the center take bonus "crush" damage (15 per overlapping enemy). Designed for pulling groups together and detonating them. |
| **Crystal** | **Prismatic Fortress** | Damage Dealt | Summon (indefinite) | Creates 6 crystal turrets in a hexagonal pattern around the player's current position. Each turret has 40 HP and fires a light beam at the nearest enemy every 1.5 seconds for 12 damage. Beams that pass through other crystals are amplified (+8 damage per crystal passed through). Turrets are destructible — enemies will target them. Turrets persist until destroyed or the room is cleared. Rewards positional play — setting up the fortress in a good spot matters. |
| **Decay** | **Necrosis** | HP Threshold | Sacrifice | Sacrifice your current active element (it is removed from your build, opening a slot). In exchange: all enemies lose 30% of their current HP instantly, all dead enemies in the room reanimate as allied undead (50% of original HP, basic melee AI) for the rest of the room, and the player gains +25% damage for the rest of the floor. Enormous power at the cost of build integrity — a true desperation play. |
| **Eclipse** | **Twilight Veil** | Timed Buildup | Transformation (10s) | Player exists in both Light and Dark states simultaneously. Visually flickering between radiant and shadow forms. Light-state attacks apply Blessed to self and Blind enemies. Dark-state attacks apply Cursed to enemies and grant lifesteal (20% of damage dealt). States alternate every 1.5 seconds automatically. All ability cooldowns are halved during the transformation. A rhythmic, skill-rewarding ultimate — mastering the alternation timing maximizes output. |

#### 4.6.6 Tier 2 Combination Ultimates (16)

| Element | Ultimate Name | Charge | Activation | Effect Summary |
|---------|--------------|--------|------------|----------------|
| **Mud Geyser** | **Yellowstone** | Elemental Saturation | Channel (3s) | Room fills with geothermal vents. 8 random geysers erupt over 6 seconds — each launches enemies airborne (juggle-able), deals 35 damage, and coats them in scalding mud (Burning + Entangled for 3s). Player can trigger extra eruptions by heavy-attacking the ground (up to 3 bonus geysers). |
| **Superheated** | **Meltdown** | HP Threshold | Sacrifice | Player's body superheats to critical temperature. Costs 30% max HP. For 8 seconds: melee attacks deal 3x damage, every hit creates a steam explosion (15 AoE damage), and the player leaves melting footprints that damage enemies (8 damage/s). At the end, the player vents all remaining heat in a 360° blast (40 damage). Self-damage makes it a glass cannon moment. |
| **Storm** | **Tempest Wrath** | Combo Reactions | Field (10s) | The room becomes a thunderstorm arena. Rain falls constantly (all surfaces become wet — enabling Conduction combos). Lightning strikes a random enemy every 1.5 seconds for 30 damage + Shocked. Wind gusts push enemies in a random direction every 3 seconds. The player is immune to Shocked and all lightning. Chaotic, high-damage, encourages adaptive play. |
| **Magnetic** | **Polarity Shift** | Damage Dealt | Instant | All metal-bearing enemies (armored enemies, weapon-wielders) are violently pulled to a central point and take 40 crush damage. All projectiles currently in flight reverse direction. For the next 10 seconds, the player has a magnetic field — enemy projectiles curve away (-60% accuracy) and thrown/metallic attacks boomerang back to their source. Non-metal enemies (slimes, wisps) are unaffected by the pull but still affected by the projectile field. |
| **Obsidian** | **Glass Cannon** | Kill Streak | Transformation (10s) | Player's body becomes obsidian — razor-sharp and brittle. All attacks deal +80% damage and have extended range (obsidian blade projections). However, player takes +50% damage from all sources. Each kill during the transformation extends the duration by 1.5 seconds (max +6s extension). Rewards aggression — if you keep killing, you keep the power. One bad hit can end you. |
| **Volcanic Ash** | **Pyroclastic Flow** | Timed Buildup | Field (8s) | A wall of superheated ash rolls across the room from one side to the other over 8 seconds. Enemies caught in the flow take 12 damage/s, are Blinded, and are pushed along with it. Player is immune and can fight freely while the flow herds enemies. Enemies pinned against walls by the flow take double damage. Direction of the flow is aimed by the player on activation. |
| **Thermal Shock** | **Flash Freeze/Burn** | Damage Dealt | Instant × 2 | Two-part ultimate. First activation: everything on screen is instantly Frozen. Second activation (must be used within 4 seconds): everything on screen is instantly set to max-stack Burning. The transition from Frozen to Burning triggers Shatter on every affected enemy simultaneously (50 damage each). If the player delays the second activation, the freeze lasts longer but the Shatter damage doesn't increase — the decision is about timing and positioning between the two presses. |
| **Permafrost** | **Glacial Bastion** | Damage Taken | Summon (indefinite) | Creates a fortress of ice walls around the player in a 5×5 tile area. Walls have 80 HP each, block enemy movement and projectiles, and chill enemies that melee-attack them (Frozen on 3rd hit). The player can shatter any wall on command (aim + interact) for 40 AoE damage and Frozen application. Functions as both defense and ammunition — hide behind walls, then detonate them offensively. Walls persist until destroyed. |
| **Toxic Fume** | **Flashpoint** | Combo Reactions | Instant (delayed) | Player releases a massive invisible gas cloud filling 70% of the room over 3 seconds. Gas is visually subtle (faint green haze). After 3 seconds OR on the player's next fire-element attack (whichever comes first): the gas ignites in a catastrophic explosion. Damage scales with gas coverage — 60 damage at full spread, less if ignited early. Enemies in the center take 1.5x. Toxic Ignition combo triggers on every poisoned enemy caught in the blast. |
| **Antivenom** | **Panacea** | Damage Taken | Instant | Instantly converts all active negative status effects on all enemies into healing for the player (5 HP per status stack removed from enemies). Then applies a 10-second aura: any status effect an enemy attempts to apply to the player is reflected back onto the attacker at double strength. If no enemies have status effects, instead fully heals the player and grants 5 seconds of status immunity. A reactive ultimate that punishes status-heavy enemy compositions. |
| **Shadow Crystal** | **Hall of Mirrors** | Elemental Saturation | Summon (12s) | Creates 4 shadow duplicates of the player. Duplicates copy the player's movements with a 0.5-second delay and deal 40% of the player's damage. Duplicates can take 1 hit before shattering (shatter deals 20 AoE dark damage). Enemies cannot distinguish duplicates from the real player (all have identical visual, including current visual tier). If a duplicate shatters on an enemy that targeted it, the enemy is Blinded for 3 seconds. |
| **Prism** | **Kaleidoscope** | Kill Streak | Transformation (8s) | Every ability the player casts splits into 3 copies at 60° angles. Projectiles become prismatic (cycle through all element damage types, hitting whatever the enemy is weakest to). Beam-type abilities become wider and refract off walls. For 8 seconds, the player is a walking rainbow of destruction. Visual spectacle is extreme — the entire room fills with multicolored projectiles. |
| **Dimensional** | **Rift Walk** | Combo Reactions | Transformation (10s) | Player phases partially out of reality. Can walk through walls and enemies (passing through an enemy deals 20 damage). Player takes -50% damage from all sources. Abilities can be cast from inside walls (enemies cannot target the player while inside geometry). Every 2 seconds, a rift echo spawns at the player's previous position and dashes toward the nearest enemy for 25 damage. Untouchable, relentless, eerie. |
| **Gravity** | **Singularity Engine** | Timed Buildup | Summon (10s) | A miniature black hole orbits the player at medium range. It pulls nearby enemies toward it (strong pull, enemies must actively resist by moving away). Enemies that touch it take 20 damage/s and are trapped in orbit. After 10 seconds (or on manual detonation), the singularity collapses: all trapped enemies take 30 damage per enemy caught in the singularity (rewards patience — more enemies caught = exponentially more damage). |
| **Supernova** | **Stellar Collapse** | Elemental Saturation | Channel (4s) | The longest channel in the game. Player gathers energy visibly (the room dims, light streams toward the player). Interruptible — and enemies will try. On completion: a supernova detonates centered on the player, dealing 150 damage to everything on screen. Enemies near the center take 200. Destructible terrain is obliterated. A 3-second "aftermath" applies Burning and Blinded to all survivors. The big red button of ultimates — if you can land it, the room is over. |
| **Tidal Force** | **Lunar Tide** | Timed Buildup | Field (12s) | The room enters a tidal cycle. Every 3 seconds, the "tide" shifts between high and low. High tide: water floods the room knee-deep, enemy movement -40%, water-element abilities +50% damage, Conduction combos trigger automatically on Shocked enemies. Low tide: water recedes, ground is muddy (enemy movement -20%), earth-element abilities +50% damage, Entangled enemies take double damage. Rhythmic, strategic — rewards players who adapt their attacks to the tidal cycle. |

#### 4.6.7 Tier 3 (Ultimate Element) Ultimates (7)

These are the apex of the ultimate system. Tier 3 ultimates are rare, devastating, and should feel like wielding a force of nature.

| Element | Ultimate Name | Charge | Activation | Effect |
|---------|--------------|--------|------------|--------|
| **Cataclysm** | **World Ender** | Damage Dealt + Damage Taken (hybrid — both meters contribute to a shared charge, meaning dealing OR taking damage fills it) | Channel (3s) → Field (10s) | The room undergoes an extinction-level event. Volcanic eruptions and lightning strikes hit random positions every 0.5 seconds (25 damage each). The floor cracks and splits — enemies can fall into fissures (instant kill for Fodder, 80 damage to others). Persistent lava rivers flow across the room. The player hovers above the destruction, immune to ground effects, raining down enhanced abilities (+50% damage, +50% AoE size). After 10 seconds, the room collapses into rubble and is replaced by a scorched wasteland (flat terrain, no cover, all hazards removed). |
| **Entropy** | **Heat Death** | HP Threshold (activates below 15% HP — lower threshold than normal, but...) | Sacrifice + Transformation (15s) | The player's HP is locked at 1 for 15 seconds (cannot die, cannot heal, cannot take damage). During this time: a freezing/burning aura radiates outward, dealing 20 damage/s to all enemies in a large radius. Enemies killed during Heat Death restore 5% max HP to the player when the effect ends. The player's attacks apply both Frozen AND Burning simultaneously (triggering Shatter on every single hit). When Heat Death expires, the player's HP is set to the amount earned from kills (minimum 1). A true "I refuse to die" ultimate — you're already dead, you're just deciding how many enemies you're taking with you. |
| **Architect** | **Rewrite** | Elemental Saturation | Transformation (12s) | The player gains the ability to reshape the room. While active: aim at any point and press light attack to raise a crystal wall (2 tiles wide, blocks movement and projectiles, 100 HP). Aim and press heavy attack to create a crystal spike trap at target location (enemies walking over it take 40 damage + Entangled). Press dodge to instantly teleport to any crystal structure you've created. Maximum 8 structures. After 12 seconds, all structures become permanent for the rest of the room. The most strategic ultimate — it's only as strong as the player's spatial thinking. |
| **Maelstrom** | **Eye of Chaos** | Combo Reactions (but only 2 reactions needed due to Tier 3 power) | Summon (indefinite, grows over time) | A permanent storm vortex spawns at the player's position (follows the player at walking speed). The vortex starts small (2-tile radius) and grows by absorbing enemy projectiles and defeated enemies. Starts at 5 damage/s, scales up to 25 damage/s at maximum size. Pulls in nearby items (Essence, shards). The vortex persists for the entire room (or until the player voluntarily dismisses it). Maximum size reached after absorbing ~10 enemies or ~30 projectiles. At maximum size, it also applies random status effects to enemies caught in it. |
| **Singularity** | **Big Bang** | Kill Streak (10 kills, the highest requirement of any ultimate) | Channel (5s) → Instant | The most powerful single attack in the game. 5-second channel during which the player is completely vulnerable and immobile. A sphere of compressed reality forms above the player, visibly warping the screen. On completion: the sphere detonates. **Every enemy on screen takes 250 damage.** Survivors are stunned for 3 seconds, Cursed, and Blinded. Destructible terrain in the entire room is obliterated. Screen whites out for 0.5 seconds. If interrupted, NO charge is refunded — the investment is lost entirely. The highest risk, highest reward moment in the game. |
| **Aurora** | **Radiant Symphony** | Timed Buildup (30s, faster than normal due to Tier 3) | Transformation (15s) | The player becomes an aurora — a flowing, ethereal being of pure prismatic light. For 15 seconds: the player is intangible (cannot take damage, cannot be targeted, passes through all geometry). Prismatic waves pulse outward every 2 seconds, dealing 30 damage to all enemies and healing the player for 15 HP per pulse. Each wave cycles through a different element type (applying the corresponding status effect). The player can still use all abilities during the transformation, and all abilities gain the prismatic cycling effect (+30% damage, rotate element type). The "beautiful" ultimate — screens fill with color, the music swells, and nothing can touch you. |
| **Absolute Zero** | **Frozen Eternity** | Damage Taken (but at half the normal threshold — fills extremely fast when the player is getting hit) | Instant → Field (8s) | On activation: everything stops. Every enemy, every projectile, every particle effect is Frozen solid for 4 seconds — no exceptions, no immunity, no resistance. During the freeze: the player moves freely and every attack on a frozen enemy is a guaranteed critical hit (2x damage) AND triggers Shatter (50 bonus damage). After the 4 seconds, a secondary effect kicks in: for 8 additional seconds, the room temperature plummets. Enemy movement speed is permanently reduced by 40% for the rest of the room. Enemies that were Shattered during the freeze leave frozen corpses that act as obstacles (blocking enemy pathing). The room becomes a frozen graveyard that the player navigates freely while enemies stumble through their own dead. |

#### 4.6.8 Stick Figure Secret Ultimate

If the player reaches **Floor 10 without acquiring any elements** (remaining a Tier 0 stick figure the entire time — extremely difficult), a hidden ultimate unlocks:

| Ultimate Name | Charge | Activation | Effect |
|--------------|--------|------------|--------|
| **Blank Canvas** | Kill Streak (5 kills) | Transformation (15s) | The stick figure sheds its lines and becomes pure white light in humanoid form. For 15 seconds: the player's base attacks deal 50 damage (up from 8/8/12), dodge roll has 0 cooldown and no stamina cost, and the player leaves afterimages that repeat the player's attacks 0.5 seconds later. Every kill during the transformation adds 1 second to the duration. A reward for masochistic players who can climb with nothing. |

**Meta-Progression Interaction:** Discovering Blank Canvas permanently adds it to the Codex. The Archivist NPC comments on it with unique dialogue. It does NOT unlock for use in normal runs — it only activates under the "no elements by Floor 10" condition.

#### 4.6.9 Ultimate Charge HUD Element

The ultimate charge indicator sits **below the HP/Stamina bars** as a circular meter. Its appearance changes based on the charge type:

| Charge Type | Visual Style |
|-------------|-------------|
| Damage Dealt | Sword icon in center, fire-like fill animation |
| Damage Taken | Shield icon in center, cracking/mending animation |
| Combo Reactions | 3-segment ring, each segment lights on combo |
| Kill Streak | Skull icons stack around the ring, shatter animation on hit |
| Timed Buildup | Clock sweep animation |
| HP Threshold | Heart icon, greyed out until threshold, burns red when active |
| Elemental Saturation | Element icon in center, counter ticks up |

When fully charged, the ring pulses brightly and the V key prompt flashes on screen briefly (once, not persistently — avoid HUD noise).

---

### 5.1 Overall Layout

The tower has **25 floors** divided into **5 zones** of 5 floors each. **Zone elemental themes are randomized** — each of the first four zones is assigned a different base element, and the fifth zone is always a chaotic mix. No two zones in a single run share the same element.

**Tutorial Phase (First 3 Runs):**

During the player's first 3 runs, zone order is fixed to teach mechanics gradually:
- Run 1: Fire → Water → (player likely dies before Zone 3)
- Run 2: Fire → Water → Air → Earth → Apex
- Run 3: Earth → Air → Water → Fire → Apex

After Run 3, the tutorial flag is set in save data and all future runs use full randomization.

**Post-Tutorial Zone Generation:**

At the start of each run, the game:
1. Selects 4 of the 6 base elements (random, no repeats)
2. Assigns them to Zones 1–4 in random order
3. For each element, selects one of 6 **biome variants** (see §5.1.1)
4. Zone 5 (The Apex) is always the final zone and draws from all elements

This means the player could face a Light zone first and a Fire zone fourth. Difficulty scaling (§6) is tied to zone *position* (1st through 5th), not to specific elements. A Water zone in position 1 is easier than a Water zone in position 4.

| Zone Position | Floors | Difficulty Role | Element |
|--------------|--------|----------------|---------|
| 1st | 1–5 | Introductory — teaches mechanics, lower enemy count | Random (from 6) |
| 2nd | 6–10 | Introduces environmental hazards, more complex encounters | Random (different from Zone 1) |
| 3rd | 11–15 | Mid-game spike, zone-specific mechanics fully deployed | Random (different from Zones 1–2) |
| 4th | 16–20 | High difficulty, demands build mastery | Random (different from Zones 1–3) |
| 5th (The Apex) | 21–25 | Maximum difficulty, all elements combined, chaos | Always mixed/all |

**Narrative Integration:** The Primordials rebuild the Crucible for each attempt with a different elemental arrangement. The narrative zone descriptions (§1B.3) describe the *testing purpose* of each position, not the specific element — the soul is tested on survival (Zone 1), adaptability (Zone 2), boldness (Zone 3), intention (Zone 4), and completeness (Zone 5), regardless of which element occupies which position.

#### 5.1.1 Biome Variants (6 Per Element, 36 Total)

Each element has 6 distinct biome variants. When a zone is assigned an element, one variant is selected randomly. This means even if a player gets a Fire zone in Zone 2 twice in a row, the biome might be completely different.

**Fire Biomes:**

| Variant | Name | Visual Identity | Unique Hazards |
|---------|------|----------------|----------------|
| F1 | **The Forge** | Industrial foundry. Molten rivers, anvil platforms, soot-stained stone. | Conveyor belts push the player/enemies. Forge hammers slam at intervals (telegraphed). |
| F2 | **The Caldera** | Volcanic crater. Black rock, lava geysers, ash-filled sky. | Lava geysers erupt on timer (ground glows before eruption). Ash clouds reduce visibility. |
| F3 | **The Hearth** | Burned-out village. Charred timbers, ember pits, collapsed structures. | Collapsing floors (cracked tiles fall after weight). Spreading fire on wooden terrain. |
| F4 | **The Sun Garden** | Desert of glass and flame-flowers. Crystallized sand, prismatic heat haze. | Heat exhaustion zones (stamina drains faster). Mirages (fake enemies/items). |
| F5 | **The Pyre** | Ceremonial temple of fire. Braziers, obsidian altars, fire-carved glyphs. | Ritual flames (certain tiles ignite periodically in patterns). Burning incense clouds (damage over time zones that drift). |
| F6 | **The Ember Wastes** | Post-inferno wasteland. Smoldering earth, dead trees, rivers of cooling magma. | Ground collapses into magma beneath. Ember storms (periodic directional fire projectiles from off-screen). |

**Water Biomes:**

| Variant | Name | Visual Identity | Unique Hazards |
|---------|------|----------------|----------------|
| W1 | **The Drowned City** | Submerged ruins. Flooded streets, barnacle-encrusted buildings, bioluminescence. | Rising water levels (floods room over time, creating wading zones that slow movement). |
| W2 | **The Coral Labyrinth** | Massive coral reef. Living walls of coral, anemone clusters, schools of fish. | Coral walls shift (maze reconfigures mid-fight). Anemone patches (contact damage + entangle). |
| W3 | **The Glacial Shore** | Frozen coastline. Ice sheets, frozen waves, half-submerged icebergs. | Ice floor (reduced traction, slide on dodge). Thin ice tiles (break after 2 steps, water underneath). |
| W4 | **The Rain Temple** | Open-roofed temple in perpetual rain. Waterfalls, reflecting pools, moss-covered pillars. | Constant rain (all surfaces are wet — enables Conduction combos globally). Flash floods (periodic wave across the room). |
| W5 | **The Abyss** | Deep ocean trench. Near-total darkness, pressure distortion, anglerfish lures. | Pressure zones (player takes 2 damage/s in deep areas). Light sources are enemy lures (approaching them triggers ambush). |
| W6 | **The Tide Pools** | Coastal grottos. Shallow pools, kelp forests, tidal rhythms. | Tidal cycle (water rises and falls every 20 seconds, changing traversable area). Jellyfish hazards in water zones. |

**Air Biomes:**

| Variant | Name | Visual Identity | Unique Hazards |
|---------|------|----------------|----------------|
| A1 | **The Gale Spire** | Towers connected by wind bridges. Open sky, vertigo-inducing drops. | Wind gusts (periodic knockback in one direction). Falling off platforms deals 20 damage and respawns at edge. |
| A2 | **The Cloud Court** | Palace on clouds. Marble floors over nothing, floating columns, mist. | Clouds dissipate (floor tiles disappear and reappear). Updrafts and downdrafts (launch player or slam them). |
| A3 | **The Storm Front** | Flying through a thunderstorm. Lightning, rain, turbulence. | Lightning strikes (random floor tiles, telegraphed by static charge). Strong wind (constant directional push). |
| A4 | **The Aviary** | Enormous birdcage-like structure. Perches, nests, feathers, open lattice walls. | Nest ambushes (enemies burst from nests when player approaches). Feather drifts (obscure visibility). |
| A5 | **The Vacuum** | Airless void between winds. Silent, floating debris, stillness punctuated by violent gusts. | No-air zones (stamina drains rapidly). Sudden wind bursts (zero to hurricane with 1 second warning). |
| A6 | **The Singing Caves** | Hollow mountain with wind channels. Tunnels howl, acoustics distort, echoes everywhere. | Sound-based enemy detection (enemies hear ability use from further away). Resonance chambers (abilities used inside get amplified AoE but alert all enemies on the floor). |

**Earth Biomes:**

| Variant | Name | Visual Identity | Unique Hazards |
|---------|------|----------------|----------------|
| E1 | **The Root Network** | Massive underground root system. Organic tunnels, bioluminescent fungi, living walls. | Roots grab (vines Entangle player if they stand still 2+ seconds). Spore clouds (poison zones). |
| E2 | **The Crystal Caverns** | Geode interior. Amethyst walls, quartz pillars, prismatic reflections. | Crystal shards (ground spikes erupt when crystals are damaged). Reflective surfaces redirect projectiles. |
| E3 | **The Quarry** | Excavated mine. Scaffolding, mine carts, exposed stone layers. | Mine cart rails (carts roll through periodically, deal damage and knockback). Unstable scaffolding (collapses under weight). |
| E4 | **The Burial Ground** | Ancient cemetery. Stone monuments, crumbling mausoleums, disturbed earth. | Enemies emerge from graves (spawns mid-fight from pre-placed graves). Tombstones block projectiles but can be destroyed. |
| E5 | **The Living Mountain** | A mountain that breathes. Tremors, shifting stone, geological pulse. | Earthquakes (screen shake + random tile damage every 30 seconds). Mountain breathing (rooms contract and expand slightly, moving walls). |
| E6 | **The Petrified Forest** | Ancient forest turned to stone. Stone trees, mineral leaves, fossil-embedded floors. | Petrified trees topple when damaged (large AoE, usable against enemies). Fossil traps (step on fossils to trigger bone-spike eruption). |

**Light Biomes:**

| Variant | Name | Visual Identity | Unique Hazards |
|---------|------|----------------|----------------|
| L1 | **The Prism Halls** | Crystalline palace. Light refracts everywhere, rainbow caustics on walls. | Beam hazards (light beams cross rooms, deal damage on contact, can be redirected by pushing crystal blocks). |
| L2 | **The Dawn Fields** | Eternal sunrise landscape. Golden grass, long shadows, warm light. | Shadow zones (areas in shadow heal enemies slowly). Light zones (areas in light heal player slowly). Positioning matters. |
| L3 | **The Lighthouse** | Interior of a massive lighthouse. Rotating beam, spiral architecture. | Rotating light beam (sweeps the room, damages enemies it hits, Blinds player if facing it). |
| L4 | **The Star Chamber** | Celestial observatory. Constellations on the ceiling, starlight pillars, cosmic void below glass floor. | Starfall (constellation patterns on the floor telegraph where star-bolts will strike). Void floor (glass cracks under sustained combat, areas become pits). |
| L5 | **The Gilded Archive** | Golden library. Illuminated manuscripts, light-reading podiums, warm glow. | Manuscript guardians (books animate and attack when disturbed). Light-sealed doors (must activate light sources in order to progress). |
| L6 | **The Aurora Tundra** | Northern lights over frozen expanse. Dancing colors in the sky, ice and light. | Aurora surges (periodic screen-wide light pulse that applies random status effects to everyone — player and enemies). |

**Dark Biomes:**

| Variant | Name | Visual Identity | Unique Hazards |
|---------|------|----------------|----------------|
| D1 | **The Shadow Weald** | Dark forest. Twisted trees, no sky visible, things moving at the edge of vision. | Limited visibility (player has a light radius of ~5 tiles). Ambush enemies (spawn from darkness when player's back is turned). |
| D2 | **The Nightmare** | Surreal dreamscape. Impossible geometry, M.C. Escher-like room connections. | Room layout shifts (doors lead to unexpected rooms). Gravity zones (walk on walls or ceiling in certain areas). |
| D3 | **The Crypt** | Underground tomb complex. Sarcophagi, dusty corridors, cobwebs. | Trap corridors (pressure plates trigger dart walls, pit traps, ceiling spikes). Locked sarcophagi (contain loot OR enemy ambush, 50/50). |
| D4 | **The Ink Sea** | Black liquid fills everything below knee height. Ink-stained architecture, calligraphy walls. | Ink tendrils (grab player from the ink sea, must dodge or take damage). Ink enemies (rise from the liquid, hard to see coming). |
| D5 | **The Eclipse Garden** | Garden frozen at the moment of a solar eclipse. Permanent twilight, long shadows, wilting flowers. | Shadow clones (enemies leave shadow duplicates when they move, duplicates have 1 HP but deal real damage). |
| D6 | **The Void Rift** | Tears in reality. Floating chunks of broken world, darkness between, unstable platforms. | Platform instability (floor chunks break off and float away). Void exposure (standing in the void deals 5 damage/s). Reality tears (portals that teleport player to random room position). |

### 5.2 Floor Generation

Each floor consists of:
- **Entry room** (safe, may contain a vendor or shrine)
- **3–6 combat rooms** (procedurally selected from the current zone's biome variant room pool)
- **0–1 special rooms** (Combination Altar, treasure vault, NPC event, challenge room)
- **Boss room** (every 5th floor) or **Elite room** (non-boss floors have a chance for an elite encounter)
- **Exit room** (staircase to next floor, safe)

**Room Shapes:** Each room is an isometric arena. Rooms are rectangular with dimensions varying from small (8x8 tiles) to large (16x16 tiles). Rooms contain:
- **Destructible terrain:** Barrels, pillars, walls (can be destroyed by abilities, revealing pickups or creating sightlines)
- **Hazards:** Element-specific hazards from the current biome variant (see §5.1.1), plus element interaction (fire on water creates steam, lightning on water electrifies area)
- **Cover objects:** Indestructible pillars, low walls (enemies and players can use for positioning)

**Room Connectivity:** Linear sequence with occasional branches. The player moves room-to-room; doors lock during combat encounters and unlock when all enemies are defeated.

### 5.3 Boss Encounters — Elemental Titans

Bosses are not fixed characters. Each zone boss is a **creature-form being** matching the zone's element — a Titan that represents what life might look like if that Primordial's vision won unchallenged. The boss's specific creature form is selected randomly from the pool for that element.

**Boss Generation Rules:**
1. The boss's element matches the zone's element.
2. The boss's creature form is selected from the single-element or dual-element forms associated with that element (see §2.3). For example, a Fire zone boss might be an Efreet, a Salamander, a Phoenix, or a Solar Dragon.
3. The boss's moveset is built from the element's ability pool but scaled to boss power (2–3x damage, larger AoE, additional mechanics).
4. Each creature form has distinct boss behaviors — a Phoenix boss fights differently than an Efreet boss, even though both are Fire Titans.

**Zone 5 (The Apex) Boss — The Convergence:**

The Apex boss is always **The Convergence** — the mirror-construct from §1B.8. This is the only fixed boss. It adapts to the player's build, uses the player's most-used element, and has 3 phases.

#### 5.3.1 Fire Titan Pool

| Creature Form | Boss Name | Fighting Style | Signature Mechanic |
|--------------|-----------|---------------|-------------------|
| **Efreet** | Pyraxis's Champion | Slow, devastating melee. Ground pound attacks create expanding fire rings. | **Magma Armor** — Takes reduced damage until armor is "cooled" by hitting it with Water/Ice abilities. Armor regenerates after 10 seconds. |
| **Phoenix** | The Eternal Flame | Fast, aerial. Swoops across the arena, leaves fire trails. | **Rebirth** — When reduced to 0 HP the first time, explodes into a fire nova and reforms at 40% HP. Only dies permanently on the second kill. |
| **Salamander** | The Furnace Crawler | Low, wide, charges across the room. Tail sweep attacks. | **Molten Trail** — Everywhere the boss walks becomes lava for 5 seconds. The arena progressively becomes a lava field, shrinking safe space. |
| **Solar Dragon** | The Blinding Wyrm | Ranged-focused. Breath attacks in sweeping arcs. | **Solar Charge** — Absorbs light in the room (screen darkens), then releases it as a massive beam that sweeps 180°. Must dodge behind cover. |
| **Balrog** | The Pit Lord | Heavy, terrifying. Whip and flame sword. | **Shadow Flame Arena** — The edges of the arena are dark fire. The safe area shrinks over the fight. Boss can walk through the edges freely. |
| **Djinn** | The Smoke King | Phases between solid and gaseous. Unpredictable attack patterns. | **Vapor Form** — Periodically becomes untargetable smoke, drifts to a new position, then resolidifies with an AoE attack. Player must read the smoke movement to predict where the attack will land. |

#### 5.3.2 Water Titan Pool

| Creature Form | Boss Name | Fighting Style | Signature Mechanic |
|--------------|-----------|---------------|-------------------|
| **Leviathan-kin** | Thalassa's Chosen | Tentacle slams, ink clouds, area denial. | **Flood Phase** — Every 25% HP lost, water level rises. At 25% HP the arena is half-flooded, slowing the player but enabling the boss to swim-dash. |
| **Ooze** | The Formless | Amorphous, splits into smaller copies when damaged. | **Mitosis** — At 50% HP, splits into 2 half-size copies. At 25% each copy splits again. Must kill all fragments within 10 seconds or they recombine at combined remaining HP. |
| **Naga** | The Coil Empress | Serpentine, constricting attacks, poison spit. | **Constrict** — Periodically coils around a section of the arena, making it impassable. Player must fight in shrinking space until the Naga repositions. |
| **Kraken** | The Deep One | Tentacles attack from off-screen. Main body exposed periodically. | **Tentacle Phase** — Boss body retreats off-screen. 4–6 tentacles emerge from room edges and attack independently. Destroying all tentacles forces the boss to re-emerge. |
| **Storm Serpent** | The Tide Fang | Fast serpentine movement, electrical water attacks. | **Electrified Pools** — Leaves water puddles that become electrified when the boss passes through them. Creates a minefield of shock zones. |
| **Jellyfish** | The Drifting Doom | Floating, passive-seeming, but tentacles are deadly. | **Tentacle Curtain** — Tentacles hang from ceiling to floor in waves. Must navigate between them while fighting. Boss drifts through its own tentacles unharmed. |

#### 5.3.3 Air Titan Pool

| Creature Form | Boss Name | Fighting Style | Signature Mechanic |
|--------------|-----------|---------------|-------------------|
| **Zephyr** | Ouranos's Whisper | Extremely fast, hard to track. Hit-and-run. | **Windwalk** — Teleports between attacks, leaving a damaging wind trail. Never stands still for more than 2 seconds. |
| **Phoenix** | The Storm Phoenix | Aerial, lightning-infused (Air+Fire variant). | **Cyclone Roost** — Perches on a tornado in the center, raining projectiles. Must destroy the tornado base (wind pillars at edges) to ground it. |
| **Griffin** | The Sky Warden | Powerful charges, claw swipes, aerial dives. | **Takeoff/Landing** — Alternates between ground and air phases. Ground phase: melee monster. Air phase: dive-bombing and wind blasts. Transition is the vulnerability window. |
| **Angel** | The Choir | Radiant, serene, devastatingly powerful. | **Hymn of Judgment** — Periodically channels a room-wide AoE (3 second charge). Can only be interrupted by breaking one of 3 floating halos that orbit the boss. |
| **Banshee** | The Wailing Wind | Phases through walls, scream attacks. | **Lament** — Screams create expanding ring shockwaves. Multiple screams overlap, creating a bullet-hell-like pattern of concentric rings to dodge through. |
| **Thunderbird** | The Crackling Sky | Lightning attacks, storm summoning. | **Storm Eye** — Creates a safe zone in the center of the room while the rest is hammered by lightning. Safe zone shrinks over time, forcing the player to engage the boss at close range. |

#### 5.3.4 Earth Titan Pool

| Creature Form | Boss Name | Fighting Style | Signature Mechanic |
|--------------|-----------|---------------|-------------------|
| **Golem** | Lithara's Monolith | Extremely slow, extremely durable. Devastating hits. | **Crumble and Reform** — When staggered (every 25% HP), crumbles into rubble. Rubble pieces become projectile hazards for 5 seconds, then reassemble into a slightly different Golem form with new attacks. |
| **Centaur** | The Stone Charger | Charges across the arena. Trampling. | **Stampede** — Charges wall-to-wall, bouncing off walls and changing direction. Speed increases with each bounce. Must be dodge-rolled or interrupted with knockback abilities. |
| **Mammoth** | The Ancient One | Massive, tusk attacks, ground pounds. | **Permafrost Aura** — Freezing aura around the boss slows player when near. Must use ranged attacks or dash through the aura for melee hits and dash back out. |
| **Treant** | The Elder Grove | Summons root minions, area control. | **Root Network** — Roots spread across the floor during the fight. Standing on roots heals the boss 5 HP/s per player tile on roots. Must constantly destroy root patches while fighting. |
| **Griffin** | The Stone Griffin | Earth+Air variant, rocky feathers, ground-to-air. | **Dust Devil** — Kicks up a sandstorm on takeoff. Ground phase creates fissures. Air phase drops boulders. The arena becomes increasingly cratered. |
| **Fungal Horror** | The Rot Mother | Spore attacks, minion spawning from corpses. | **Infestation** — Every enemy killed in the arena sprouts a fungal growth that buffs the boss (+5% damage per growth). Must destroy growths or kill enemies far from the boss. |

#### 5.3.5 Light Titan Pool

| Creature Form | Boss Name | Fighting Style | Signature Mechanic |
|--------------|-----------|---------------|-------------------|
| **Seraph** | Solenne's Radiance | Multi-winged, beam attacks, holy fire. | **Judgment Beams** — Wings unfold and each fires a tracking beam. More wings unfold as HP decreases (2 at 100%, 4 at 50%, 6 at 25%). |
| **Angel** | The Illuminator | Graceful, sword-and-shield, defensive. | **Shield of Light** — Frontal shield blocks all damage. Must flank or use AoE. Shield periodically pulses outward as a damaging wave. |
| **Nereid** | The Shining Tide | Bioluminescent, graceful, water+light attacks. | **Lure Light** — Creates mesmerizing light patterns that draw the player toward them (gentle pull effect). Walking into a lure detonates it for heavy damage. Must resist the pull. |
| **Treant** | The Golden Grove | Earth+Light variant, radiant wood, golden leaves. | **Photosynthesis** — Standing in light zones heals the boss. Boss creates light zones. Player must destroy light sources or lure boss into shadow areas of the arena. |
| **Moth** | The Luminous One | Erratic flight, wing-scale attacks, dust clouds. | **Scale Burst** — Sheds luminous wing scales that drift through the room. Each scale is a proximity mine that detonates for AoE damage + status effect when approached. Arena fills with scales over time. |
| **Eclipse Knight** | The Duality | Light+Dark variant, phase-shifting. | **Phase Shift** — Alternates between Light form (heavy damage, slow) and Dark form (fast, evasive, low damage). In Light form, Dark attacks deal double. In Dark form, Light attacks deal double. Must match your damage to the boss's current phase. |

#### 5.3.6 Dark Titan Pool

| Creature Form | Boss Name | Fighting Style | Signature Mechanic |
|--------------|-----------|---------------|-------------------|
| **Wraith** | Nythara's Shadow | Incorporeal, phases through terrain, DOT focused. | **Haunting** — Becomes invisible. Player can only see the Wraith when it's about to attack (brief shimmer) or by standing in light zones (if any exist in the biome). |
| **Kraken** | The Abyssal Lord | Tentacles from darkness, gravity pulls. | **Ink Flood** — Periodically vomits ink that floods the floor. Ink zones hide trap tentacles that grab the player. Must fight in progressively obscured terrain. |
| **Arachnid** | The Web Mother | Web traps, ceiling drops, poison. | **Web Arena** — Pre-webs the entire room before the fight. Webs slow the player, but the boss moves freely on them. Burning webs with Fire clears paths but alerts the boss to your position. |
| **Lich** | The Undying Sovereign | Summons undead, necrotic blasts, curses. | **Phylactery** — Cannot be permanently killed until 3 hidden phylacteries in the arena are destroyed. Regenerates to 30% HP each time it "dies" if phylacteries remain. |
| **Banshee** | The Mourning Queen | Scream attacks, fear effects, phase-through. | **Dirge** — Every 20 seconds, screams a room-wide wail. Each wail applies a stacking debuff (-10% damage dealt per stack). Must end the fight quickly or be gradually rendered powerless. |
| **Doppelganger** | The False Self | Copies player's appearance and abilities. | **Mirror Match** — Uses the player's currently equipped abilities against them. Learns the player's attack patterns over the fight and begins predicting/countering. Must change tactics mid-fight. |

#### 5.3.7 Boss Design Rules

- Every boss has at least **2 distinct phases** with different attack patterns
- Every boss arena has **interactive elements** shaped by the biome variant (destructible pillars, hazard zones, elevation changes, biome-specific objects)
- Bosses **telegraph all attacks** with a minimum 0.5 second windup (1.0 second for high-damage attacks)
- Bosses are **immune to stunlock** (maximum 1 stun per 10 seconds)
- Boss HP and damage scales based on **zone position** (1st zone boss has base stats, 4th zone boss has 3x)
- The same creature form boss should **feel different** depending on which zone position it occupies — a Phoenix boss in Zone 1 has simpler patterns and fewer mechanics than a Phoenix boss in Zone 4
- Players can encounter the **same element in different runs** but face a **different creature form boss and different biome variant**, keeping repeat elements fresh

### 5.4 Room Events

Non-combat rooms that appear procedurally:

| Event | Description | Frequency |
|-------|-------------|-----------|
| **Element Shrine** | Choose 1 of 2–3 base elements. Shrines in a zone are weighted toward offering that zone's element (60% chance) but can offer any unlocked element. | ~1 per 2 floors |
| **Combination Altar** | Combine two held elements | 1 per 3 floors (guaranteed) |
| **Wandering Merchant** | Buy consumables, temporary buffs with in-run currency (Essence) | ~1 per 3 floors |
| **Rest Shrine** | Heal 30% max HP, choose a minor passive buff | 1 per zone (guaranteed, random floor placement) |
| **Challenge Room** | Timed combat gauntlet, bonus rewards (extra Essence, element shards) | ~1 per 4 floors |
| **Lore Tablet** | Reveals old world history and Primordial commentary (see §1B.7 for full 25-tablet narrative arc). Permanent Codex entry. Tablets 12 and 16 are dynamically personalized based on save data. | ~1 per 5 floors |
| **Gambler's Altar** | Sacrifice current HP (10–30%) for a random element or powerful consumable | Rare, ~1 per run |

---

## 6. DIFFICULTY AND PROGRESSION (WITHIN A RUN)

### 6.1 Enemy Scaling

| Floor Range | Enemy HP Multiplier | Enemy Damage Multiplier | Enemy Speed Multiplier | Enemies Per Room |
|-------------|--------------------|-----------------------|----------------------|------------------|
| 1–5 | 1.0x | 1.0x | 1.0x | 2–4 |
| 6–10 | 1.5x | 1.3x | 1.1x | 3–5 |
| 11–15 | 2.2x | 1.6x | 1.2x | 3–6 |
| 16–20 | 3.0x | 2.0x | 1.3x | 4–7 |
| 21–25 | 4.0x | 2.5x | 1.4x | 5–8 |

### 6.2 In-Run Currency: Essence

- Dropped by all enemies (1–5 per enemy, more from elites/bosses)
- Used at Wandering Merchants for consumables
- **Lost on death** (not carried between runs)
- Cannot be traded for meta-progression currency

### 6.3 Consumable Items

The player has a **3-slot consumable inventory** (does not expand):

| Item | Effect | Cost (Essence) | Rarity |
|------|--------|----------------|--------|
| Health Potion | Restore 40 HP | 30 | Common |
| Stamina Tonic | Instant full stamina + 50% regen boost for 10s | 25 | Common |
| Elemental Shard (random) | 1 shard toward a random base element (3 needed for full element) | 50 | Uncommon |
| Nullify Charm | Immune to all status effects for 15s | 60 | Uncommon |
| Phoenix Feather | On death, revive with 25% HP (consumed automatically) | 150 | Rare |
| Chaos Orb | Randomizes all enemy elemental resistances in current room | 40 | Uncommon |

---

## 7. META-PROGRESSION

### 7.1 Meta-Currency: Echoes

- Earned by **reaching milestones** during runs, NOT by grinding. This ensures the meta makes runs different, not easier.
- Echoes are **kept on death**.

| Milestone | Echoes Earned |
|-----------|--------------|
| Defeat any boss (first time) | 50 |
| Defeat any boss (subsequent) | 15 |
| Clear a floor without taking damage | 10 |
| Discover a new combination | 20 |
| Reach a new highest floor | 25 |
| Defeat the Floor 25 boss | 200 |
| Complete a challenge room | 10 |

### 7.2 The Hub — Bastion

Between runs, the player returns to **Bastion**, a persistent safe area at the base of the tower. Bastion starts as a bare stone platform with a single NPC and grows as the player invests Echoes.

**Hub Character Appearance:**

While in Bastion, the player character's visual form is **not** a blank stick figure. Instead, it reflects the **rolling average of the player's last 10 runs**. The system tracks which elements and combinations were held at the end of each run (or at death), computes the averaged elemental weights, and renders the appropriate **creature form** (see §2.3):

- **First few runs:** The hub character will be mostly stick figure with faint traces of Fire/Water coloring (since those are the only early elements). After 3–4 runs, a creature form begins to emerge.
- **Consistent build player:** A player who always runs Fire+Air builds will see a Phoenix in their hub. A player who favors Water+Dark will see a Kraken. The hub character becomes a portrait of playstyle.
- **Diverse build player:** A player who experiments broadly across many elements will trend toward the **human form** in their hub — the balanced warrior/mage that represents versatility. This is a mark of a well-rounded player.
- **Visual tier in hub** is the average of the visual tiers reached across the last 10 runs (rounded down). A player who consistently reaches Tier 3–4 in runs will have a detailed, fully-realized creature. A player who keeps dying early will have a sketchier, more stick-figure-like version of whatever creature form their weights produce.
- **After a first clear (Floor 25):** The hub character gains a subtle persistent glow/aura that marks the player as someone who has completed the tower at least once.
- **Creature blending:** If the averaged weights fall between two creature forms (e.g., 5 Fire-heavy runs and 5 Water-heavy runs), the hub character renders as a **blend** — in this case, something between an Efreet and a Leviathan-kin, which would trend toward the Djinn form (Fire+Water). The system resolves ambiguity by running the same weight calculation from §2.3 on the averaged data.

**Implementation:** The save file stores an array of the last 10 run-end element snapshots (element IDs + visual tier). The hub character renderer computes averaged elemental weights across all entries using the weight rules from §2.3, then selects the appropriate creature form and visual tier. If fewer than 10 runs have been completed, use however many exist.

**Save data addition:**
```json
{
  "run_history_visuals": [
    {"elements": ["FIRE", "STEAM"], "visual_tier": 2},
    {"elements": ["LIGHTNING", "AIR"], "visual_tier": 2},
    {"elements": ["ICE", "PERMAFROST", "EARTH"], "visual_tier": 3},
    ...
  ]
}
```

**Hub Structures (unlocked with Echoes):**

| Structure | Cost | Effect |
|-----------|------|--------|
| **Element Well** (Tier 1) | 50 | Unlocks Air and Earth elements for future runs (initially locked behind first Floor 5 clear) |
| **Element Well** (Tier 2) | 200 | Unlocks Light and Dark elements for future runs (initially locked behind first Floor 15 clear) |
| **Alchemist's Table** | 75 | View all discovered combination recipes between runs |
| **Alchemist's Memory** | 150 | See names of undiscovered combos at Combination Altars during runs |
| **Alchemist's Intuition** | 300 | See full descriptions of undiscovered combos at altars |
| **Training Dummy** | 50 | Test abilities in the hub (spawns targetable dummy) |
| **Training Arena** | 150 | Fight wave-based encounters in hub for practice (no rewards) |
| **Armory** (Tier 1) | 100 | +10 max HP for all future runs |
| **Armory** (Tier 2) | 200 | +20 max HP total |
| **Armory** (Tier 3) | 350 | +30 max HP total |
| **Armory** (Tier 4) | 500 | +40 max HP total |
| **Armory** (Tier 5) | 750 | +50 max HP total |
| **Stamina Forge** (Tier 1) | 100 | +10 max stamina for all future runs |
| **Stamina Forge** (Tier 2) | 200 | +20 max stamina total |
| **Stamina Forge** (Tier 3) | 350 | +30 max stamina total |
| **Merchant's Guild** | 100 | Wandering Merchants appear more frequently (1 per 2 floors instead of 1 per 3) |
| **Merchant's Warehouse** | 200 | Merchants stock +2 additional items |
| **Cartographer's Tower** | 150 | Shows room types on floor minimap before entering |
| **Shrine of Foresight** | 250 | Element Shrines offer 3 choices instead of 2 |
| **Codex Pedestal** | 50 | Houses the Codex — tracks all lore tablets, enemy bestiary, combo recipes |
| **The Gate** (Tier 1) | 300 | Unlocks Zone 4 shortcut start (start run on Floor 16 with pre-set loadout of 2 random unlocked elements) |
| **The Gate** (Tier 2) | 500 | Unlocks Zone 5 shortcut start (start on Floor 21 with 3 random elements + 1 Tier 1 combo) |

### 7.3 NPCs

NPCs appear in the hub as the player progresses. They provide lore, quests, and unlock specific features. For narrative backstories and dialogue tone, see §1B.6.

| NPC | Unlock Condition | Function |
|-----|-----------------|----------|
| **The Keeper** | Always present | Tutorial, basic tips, meta-progression shop interface. Acts as narrative anchor for early runs (see §1B.9). |
| **The Alchemist** | Discover 5 combinations | Provides combination hints, unlocks Alchemist structures |
| **The Cartographer** | Reach Floor 10 | Sells Cartographer's Tower upgrade, provides zone lore |
| **The Merchant Prince** | Spend 500 total Essence across all runs | Sells Merchant upgrades, offers daily deals (one per real-world day, costs Echoes) |
| **The Archivist** | Find 10 Lore Tablets | Manages Codex, provides backstory, hints at secret combinations |
| **The Challenger** | Complete 5 Challenge Rooms | Unlocks Training Arena, offers weekly challenge modifiers |
| **The Wanderer** | Defeat the Floor 25 boss once | Unlocks New Game+ style modifiers (see §7.4) |

### 7.4 New Game+ Modifiers (Post-First-Clear Content)

After the first full tower clear, **The Wanderer** offers **Tower Modifiers** that can be toggled for future runs. These make runs harder but more rewarding:

| Modifier | Effect | Echo Bonus |
|----------|--------|------------|
| **Fragile** | Player max HP halved | +50% Echoes |
| **Accelerated** | All enemies 25% faster | +30% Echoes |
| **Elemental Chaos** | Enemy resistances randomized each room | +25% Echoes |
| **Scarcity** | 50% fewer Element Shrines and Altars | +40% Echoes |
| **Boss Rush** | Boss on every 3rd floor instead of every 5th | +60% Echoes |
| **True Blank Slate** | No meta-progression stat bonuses apply | +100% Echoes |

Multiple modifiers can be stacked. Echo bonuses are additive.

---

## 8. ENEMY DESIGN

### 8.1 Enemy Categories

| Category | Behavior | HP Tier | Example |
|----------|----------|---------|---------|
| **Fodder** | Simple melee/ranged, low threat individually, dangerous in groups | Low | Stick Grunt, Ink Blob |
| **Bruiser** | High HP, slow, heavy-hitting melee | High | Stone Golem, Armored Shade |
| **Ranged** | Low HP, keeps distance, projectile attacks | Low | Fire Imp, Crystal Archer |
| **Mobile** | Medium HP, fast, flanking/dodging behavior | Medium | Wind Sprite, Shadow Runner |
| **Elite** | Enhanced version of any type. Glowing outline, 2x HP, extra ability, drops element shards | Varies (2x base) | Any enemy type + "Elite" prefix |
| **Support** | Buffs/heals other enemies, high priority target | Low-Medium | Chanting Pillar, Dark Priest |

### 8.2 Enemy AI Behaviors

All enemies use a **behavior tree** system with the following core behaviors:

- **Chase:** Move toward player. Pathfinding around obstacles.
- **Attack:** Execute attack when in range. Different attacks have different ranges and windups.
- **Flee:** Move away from player (used by ranged enemies when player gets close).
- **Flank:** Move to player's side or rear. Used by Mobile enemies.
- **Support:** Stay near allies, cast buff/heal abilities. Used by Support enemies.
- **Patrol:** Idle movement pattern before player detection. Enemies have a detection radius (varies by type, 6–12 tiles).

**Critical AI Rule:** Enemies must telegraph all attacks. Minimum 0.4 second windup for normal attacks, 0.8 second for heavy attacks. The telegraph must be visually distinct (colored indicator on ground, windup animation, audio cue).

### 8.3 Element-Based Enemy Rosters

Enemies are tied to **elements**, not fixed zones. When a zone is assigned an element, it draws from that element's enemy roster. Difficulty scaling (HP, damage, speed) is handled by the zone position multiplier (§6.1), not by the enemies themselves.

**Fire Enemies:**
| Enemy | Category | Attack | Notes |
|-------|----------|--------|-------|
| Ember Sprite | Fodder | Melee punch with ignite chance, 8 damage | Leaves small fire patch on death |
| Torch Sentry | Ranged | Fire bolt, 12 damage, chance to ignite | Stands on elevated positions when available |
| Magma Brute | Bruiser | Ground slam, 25 damage + lava pool | Slow, leaves lava footprints |
| Flame Dancer | Mobile | Quick dash attacks, 10 damage, dodges frequently | Leaves fire trails during dashes |
| Brazier Priest | Support | Buffs nearby allies with Burning aura (contact ignites player) | Weak direct attack, high priority target |

**Water Enemies:**
| Enemy | Category | Attack | Notes |
|-------|----------|--------|-------|
| Drowned Husk | Fodder | Melee claw, 10 damage, chance to slow | Rises from water tiles if biome has them |
| Tide Caster | Ranged | Water bolt, 12 damage + pushback | Creates small puddles at impact point |
| Tidal Brute | Bruiser | Wave slam, 25 damage, wide AoE | Faster in water, slower on dry ground |
| Deep Lurker | Mobile | Ambush from water/shadows, 18 damage | Submerges between attacks, hard to target |
| Coral Priest | Support | Heals allies 10 HP/s in radius | Roots in place while channeling, vulnerable |

**Air Enemies:**
| Enemy | Category | Attack | Notes |
|-------|----------|--------|-------|
| Wind Wisp | Fodder | Gust push, 5 damage + knockback | Dangerous near edges/pits, low damage but disruptive |
| Storm Archer | Ranged | Lightning arrow, 14 damage + Shocked | High accuracy, low HP |
| Gale Knight | Bruiser | Charge attack, 28 damage, crosses room | Telegraphed but very fast, hard to dodge in tight spaces |
| Cloud Dancer | Mobile | Teleporting melee, 12 damage | Hardest Mobile to pin down, blinks every 3 seconds |
| Thunder Totem | Support | Gives nearby enemies Shocked aura | Stationary, acts as area control. Destroy to remove aura. |

**Earth Enemies:**
| Enemy | Category | Attack | Notes |
|-------|----------|--------|-------|
| Stone Grunt | Fodder | Melee punch, 10 damage | Highest HP of all Fodder enemies |
| Crystal Archer | Ranged | Crystal shard, 12 damage, pierces one target | Shards embed in walls and shatter if hit (secondary AoE) |
| Stone Golem | Bruiser | Ground slam, 30 damage, small AoE | Extremely slow but staggers player on hit |
| Rubble Rat | Mobile | Quick bite, 6 damage, erratic movement | Comes in packs, individually weak but hard to track |
| Moss Shaman | Support | Creates healing mushroom patches, 8 HP/s to allies standing on them | Also creates entangling root patches for player |

**Light Enemies:**
| Enemy | Category | Attack | Notes |
|-------|----------|--------|-------|
| Light Fragment | Fodder | Radiant burst, 8 damage + brief Blind | Small, fast, dies in 1–2 hits but applies annoying debuff |
| Prism Turret | Ranged | Split beam, 10 damage × 3 directions | Stationary, must be approached and destroyed. Rotates aim. |
| Mirror Knight | Bruiser | Melee slash, 22 damage + reflects projectiles back | Frontal reflection shield, must be flanked |
| Phase Shade | Mobile | Phases through walls, backstab 20 damage | Appears behind player, must be tracked by sound cue |
| Beacon | Support | Illuminates area, buffs allies' accuracy and damage +15% | Aura-based, killing it removes the buff from all affected |

**Dark Enemies:**
| Enemy | Category | Attack | Notes |
|-------|----------|--------|-------|
| Ink Blob | Fodder | Slow projectile, 10 damage + Cursed | Splits into 2 smaller blobs on death (each has 25% HP) |
| Abyssal Eye | Ranged | Dark beam, 15 damage + Cursed | Floats, tracks player with visible "pupil" before firing |
| Armored Shade | Bruiser | Heavy slash, 28 damage + Cursed | Shadow armor reduces first hit taken to 0, then breaks |
| Shadow Runner | Mobile | Dash attack from darkness, 14 damage | Invisible until attacking, briefly visible after attack |
| Dark Priest | Support | Curses player directly (applies Cursed in radius) + heals allies | Highest support priority — Cursed makes everything worse |

**The Apex (Zone 5) Enemies:**

Zone 5 always uses a mixed roster drawn from all 6 element pools, plus Apex-exclusive enemies:

| Enemy | Category | Attack | Notes |
|-------|----------|--------|-------|
| Chaos Spawn | Fodder | Random element attack, 12 damage | Element type randomized per spawn |
| Reality Anchor | Bruiser | Gravity slam, 35 damage + gravity well | Pulls player and projectiles toward impact point |
| Entropy Mage | Ranged | Dual element projectiles, 16 damage each | Fires two different element projectiles simultaneously |
| Flux Runner | Mobile | Time-stuttered movement, 15 damage | Teleports in short hops, very hard to track |
| Amalgam Pillar | Support | Cycles through elements, applying matching buffs to allies | Must be destroyed during the element cycle you want to counter |

---

## 9. USER INTERFACE

### 9.1 HUD Layout

```
┌─────────────────────────────────────────────────────────────────┐
│  [HP Bar]  ████████████████░░░░  78/100                         │
│  [Stamina] ██████████████████░░  85/100                         │
│  [Ultimate: ◉ 67% — Thundergod]                                 │
│  [Floor: 7 / 25]            [Zone: Water — The Drowned City]     │
│                                                                 │
│                                                                 │
│                     (GAMEPLAY AREA)                              │
│                                                                 │
│                                                                 │
│  [Consumable 1] [Consumable 2] [Consumable 3]                   │
│  [Q: Ability 1] [E: Ability 2] [R: Ability 3] [F: Ability 4]   │
│  [Active Elements: 🔥 Fire | 💧 Water | ♨️ Steam]               │
│  [Essence: 247]                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**HUD Rules:**
- HP bar changes color: green (>50%), yellow (25–50%), red (<25%), flashing red (<10%)
- Ability icons show cooldown sweep animation
- Active elements displayed as small icons with their names; combined elements show their chain visually (Fire→Water→Steam with arrows)
- Minimap in top-right corner shows room layout of current floor (rooms explored vs unexplored, current position)
- Damage numbers float above enemies and player (white for normal, element color for elemental, yellow for combo reactions)
- Boss HP bar appears at top of screen during boss encounters

### 9.2 Menus

| Menu | Access | Contents |
|------|--------|----------|
| **Pause Menu** | ESC / Start | Resume, Settings, Codex, Abandon Run (confirm), Quit to Hub |
| **Codex** | Pause → Codex, or interact with Codex Pedestal in hub | Bestiary (enemies encountered), Alchemy Recipes (discovered), Lore Tablets (collected, displayed in both discovery order and chronological order per §1B.7, with the Archivist's commentary), Statistics, Primordial Notes (unlocked when the player discovers dynamic tablets 12 and 16) |
| **Settings** | Pause → Settings or Hub → Settings | Audio (Master, Music, SFX, Voice), Video (Resolution, Fullscreen, VSync, Quality preset), Controls (Rebindable KB+M and Controller), Accessibility (Screenshake toggle, Flash reduction, Colorblind modes, Damage number size, HUD scale) |
| **Hub Menu** | Interact with structures in hub | Structure-specific upgrade menus (see §7.2) |
| **Run Summary** | Displayed on death or tower completion | Floor reached, enemies killed, combinations discovered, elements used, Echoes earned, time elapsed, cause of death. Also captures the element/visual tier snapshot for hub character averaging. |

### 9.3 Accessibility Requirements

- **Full keyboard remapping** — every action rebindable
- **Full controller support** — Xbox/PlayStation/Generic controller layouts with button prompt swapping
- **Colorblind modes** — Protanopia, Deuteranopia, Tritanopia filters. All elemental information must be conveyed through shape/icon in addition to color.
- **Screen shake toggle** — on/off
- **Flash intensity** — slider from 0% to 100%
- **HUD scale** — 75% to 150%
- **Damage number size** — small, medium, large, off
- **Enemy telegraph duration** — Normal, Extended (+50% windup time, for players who need more reaction time)

---

## 10. AUDIO DESIGN

### 10.1 Music

| Context | Style | Notes |
|---------|-------|-------|
| Hub (Bastion) | Calm ambient, acoustic instruments, evolves as hub grows | Add layers/instruments as structures are built. Subtle elemental motifs blend in based on the player's hub character appearance (fire runs add warm tones, ice adds crystalline pads, etc.) |
| Fire zones | Rhythmic percussion, crackling textures, warm pads | Djembe, taiko, distorted bass. Intensity scales with zone position. |
| Water zones | Submerged, reverb-heavy, fluid rhythms | Muffled drums, deep bass, whale-song pads, rain textures. |
| Air zones | Wind instruments, fast tempo, open/airy mix | Flutes, strings, high energy, lots of stereo movement. |
| Earth zones | Deep, steady, grounded | Low brass, cello drones, stone percussion, patient rhythm. |
| Light zones | Crystalline, choral, precise | Bell tones, choir pads, harp arpeggios, clean and bright. |
| Dark zones | Dissonant, atmospheric, unsettling | Reversed audio, minor key drones, sparse percussion, silence as instrument. |
| The Apex (Zone 5) | Chaotic mix of all element themes | Layers from the current run's element themes collide and distort. |
| Boss encounters | Element theme intensified + creature-form-specific leitmotif | Each Titan creature form has a distinct melody layered on the element base. A Phoenix boss sounds different from an Efreet boss even though both are Fire. |
| Death screen | Single held note fading to silence | |
| Victory (tower clear) | Triumphant orchestral swell, but with an undercurrent of melancholy | Should feel earned and bittersweet — the new world is born, but the old one is truly gone now. The Primordials' motifs weave together. |

### 10.2 SFX

- Every element has a unique **audio signature** for its abilities (fire crackles, water splashes, lightning zaps, etc.)
- Combo reactions have **distinct audio stingers** (Shatter = glass break + impact, Conduction = electrical surge, etc.)
- UI sounds: menu navigate, menu select, menu back, item pickup, Essence pickup, level up/element acquire (triumphant chime), discovery (alchemy combination discovered)
- Enemy audio: footsteps (per type), attack windup (per type), hit reaction, death
- Player audio: footsteps, dodge roll whoosh, hit reaction (grunt), death, ability on cooldown (error buzz)
- **Creature form audio** (per body category, see §2.3.6): Each of the 10 body categories has a unique movement sound set. Bipedal = standard footsteps. Quadruped = galloping hoofbeats. Serpentine = slithering rasp. Arachnid = rapid clicking/tapping. Avian = wing flutters + light taps. Amorphous = squelching/flowing. Floating = ambient hum, no footsteps. Arthropod = heavy padded thuds. Geometric = metallic clanking / crystalline chiming. Insectoid = wing buzzing + light tapping. Form transition also has an audio cue (brief morph sound).
- **Primordial voice lines** (see §1B.9): Whispered, reverbed, barely audible ambient lines triggered at Element Shrines, Combination Altars, and boss antechambers after the player's first boss kill. Each Primordial has a distinct vocal texture: Pyraxis (crackling, warm), Thalassa (echoing, fluid), Ouranos (breathy, distant), Lithara (rumbling, steady), Solenne (clear, ringing), Nythara (hushed, layered). Lines are brief — 2–5 words — and should feel like overhearing something not meant for you.

---

## 11. TECHNICAL ARCHITECTURE (Godot 4.x)

### 11.1 Project Structure

```
blank_slate/
├── project.godot
├── addons/
│   └── godot_steam/                  # GodotSteam plugin
├── assets/
│   ├── sprites/
│   │   ├── player/
│   │   │   ├── stick_figure/         # Tier 0 base animations
│   │   │   ├── creatures/
│   │   │   │   ├── _shared_rigs/     # Shared animation rigs by body category
│   │   │   │   │   ├── bipedal/
│   │   │   │   │   ├── quadruped/
│   │   │   │   │   ├── serpentine/
│   │   │   │   │   ├── arachnid/
│   │   │   │   │   ├── avian/
│   │   │   │   │   ├── amorphous/
│   │   │   │   │   ├── floating/
│   │   │   │   │   ├── arthropod/
│   │   │   │   │   ├── geometric/
│   │   │   │   │   └── insectoid/
│   │   │   │   ├── # -- Single-element dominant --
│   │   │   │   ├── efreet/           # Fire
│   │   │   │   ├── leviathan/        # Water
│   │   │   │   ├── zephyr/           # Air
│   │   │   │   ├── golem/            # Earth
│   │   │   │   ├── seraph/           # Light
│   │   │   │   ├── wraith/           # Dark
│   │   │   │   ├── # -- Dual-element defaults --
│   │   │   │   ├── phoenix/          # Fire+Air default
│   │   │   │   ├── salamander/       # Fire+Earth
│   │   │   │   ├── djinn/            # Fire+Water
│   │   │   │   ├── solar_dragon/     # Fire+Light
│   │   │   │   ├── balrog/           # Fire+Dark
│   │   │   │   ├── storm_serpent/    # Water+Air default
│   │   │   │   ├── naga/             # Water+Earth default
│   │   │   │   ├── nereid/           # Water+Light
│   │   │   │   ├── kraken/           # Water+Dark default
│   │   │   │   ├── griffin/          # Air+Earth default
│   │   │   │   ├── angel/            # Air+Light
│   │   │   │   ├── banshee/          # Air+Dark
│   │   │   │   ├── treant/           # Earth+Light
│   │   │   │   ├── lich/             # Earth+Dark default
│   │   │   │   ├── eclipse_knight/   # Light+Dark
│   │   │   │   ├── # -- Tier 1 combo overrides --
│   │   │   │   ├── thunderbird/      # Lightning (overrides Phoenix)
│   │   │   │   ├── wendigo/          # Ice (overrides Storm Serpent)
│   │   │   │   ├── ooze/             # Mud (overrides Naga)
│   │   │   │   ├── arachnid/         # Poison (overrides Kraken)
│   │   │   │   ├── centaur/          # Sand (overrides Griffin)
│   │   │   │   ├── fungal_horror/    # Decay (overrides Lich)
│   │   │   │   ├── # -- Tier 2 combo overrides --
│   │   │   │   ├── jellyfish/        # Storm
│   │   │   │   ├── living_armor/     # Magnetic
│   │   │   │   ├── glass_golem/      # Obsidian
│   │   │   │   ├── mammoth/          # Permafrost
│   │   │   │   ├── slime/            # Toxic Fume
│   │   │   │   ├── moth/             # Antivenom
│   │   │   │   ├── doppelganger/     # Shadow Crystal
│   │   │   │   ├── ember_wraith/     # Volcanic Ash
│   │   │   │   ├── tardigrade/       # Gravity
│   │   │   │   └── tesseract/        # Dimensional
│   │   │   └── human/               # Balanced form (Tiers 1–4)
│   │   ├── enemies/
│   │   │   ├── zone_1/
│   │   │   ├── zone_2/
│   │   │   ├── zone_3/
│   │   │   ├── zone_4/
│   │   │   └── zone_5/
│   │   ├── effects/                  # Element particles, combo reactions
│   │   ├── ui/                       # HUD elements, icons, frames
│   │   └── environment/              # Tiles, props, destructibles per zone
│   ├── audio/
│   │   ├── music/
│   │   ├── sfx/
│   │   │   ├── player/
│   │   │   │   ├── base/             # Stick figure sounds
│   │   │   │   └── body_categories/  # Movement sounds per body type (10 categories)
│   │   │   ├── enemies/
│   │   │   ├── elements/
│   │   │   ├── ui/
│   │   │   └── ambient/
│   │   └── voice/                    # If any NPC voice lines added later
│   └── fonts/
├── scenes/
│   ├── main/
│   │   ├── main_menu.tscn
│   │   ├── hub.tscn
│   │   └── tower_run.tscn            # Main gameplay scene
│   ├── player/
│   │   ├── player.tscn               # Player character scene
│   │   └── player_visual.tscn        # Visual layer (handles tier transitions)
│   ├── enemies/
│   │   ├── base_enemy.tscn           # Inherited by all enemies
│   │   └── [enemy_name].tscn         # Per-enemy scenes
│   ├── rooms/
│   │   ├── room_base.tscn
│   │   ├── combat_rooms/             # Per-zone room layouts
│   │   ├── event_rooms/              # Shrine, altar, merchant, etc.
│   │   └── boss_rooms/               # Per-boss arena layouts
│   ├── ui/
│   │   ├── hud.tscn
│   │   ├── pause_menu.tscn
│   │   ├── codex.tscn
│   │   ├── run_summary.tscn
│   │   └── hub_menus/
│   └── effects/
│       ├── element_effects.tscn
│       └── combo_effects.tscn
├── scripts/
│   ├── core/
│   │   ├── game_manager.gd           # Global game state, scene transitions
│   │   ├── save_manager.gd           # Meta-progression persistence
│   │   ├── audio_manager.gd          # Music/SFX bus management
│   │   └── input_manager.gd          # Remappable input handling
│   ├── player/
│   │   ├── player_controller.gd      # Movement, input processing
│   │   ├── player_combat.gd          # Attack execution, ability system
│   │   ├── player_stats.gd           # HP, stamina, damage calculation
│   │   ├── player_visual.gd          # Creature form selection, tier transitions, morph animations
│   │   ├── creature_form_resolver.gd # Elemental weight calculation → creature form lookup (handles combo overrides per §2.3.4)
│   │   └── element_manager.gd        # Element inventory, combination logic
│   ├── elements/
│   │   ├── element_database.gd       # All element definitions (Resource)
│   │   ├── element_base.gd           # Base class for element abilities
│   │   ├── alchemy_system.gd         # Combination chain logic
│   │   ├── ultimate_system.gd        # Ultimate charge tracking, activation handling
│   │   ├── ultimate_data.gd          # Resource class for ultimate definitions
│   │   └── abilities/                # Individual ability scripts
│   │       ├── fire_abilities.gd
│   │       ├── water_abilities.gd
│   │       ├── steam_abilities.gd
│   │       └── ...
│   ├── enemies/
│   │   ├── enemy_base.gd             # Base class: HP, damage, drops, AI hook
│   │   ├── behavior_tree.gd          # BT implementation
│   │   ├── ai_behaviors/             # Individual behavior nodes
│   │   └── spawner.gd                # Enemy wave/room population logic
│   ├── tower/
│   │   ├── floor_generator.gd        # Procedural floor layout
│   │   ├── room_manager.gd           # Room loading, transitions
│   │   ├── room_events.gd            # Shrine, altar, merchant logic
│   │   └── boss_manager.gd           # Boss phase logic, special mechanics
│   ├── hub/
│   │   ├── hub_manager.gd            # Bastion state, structure unlocks
│   │   ├── npc_manager.gd            # NPC spawn conditions, dialogue
│   │   └── meta_progression.gd       # Echoes, unlocks, stat bonuses
│   └── ui/
│       ├── hud_controller.gd
│       ├── menu_controller.gd
│       └── codex_controller.gd
├── resources/
│   ├── elements/                     # .tres files for each element definition
│   ├── enemies/                      # .tres files for enemy stat blocks
│   ├── rooms/                        # .tres files for room templates
│   └── loot_tables/                  # .tres files for drop rates
└── tests/                            # GDScript unit tests
    ├── test_alchemy.gd
    ├── test_combat.gd
    └── test_floor_generation.gd
```

### 11.2 Key Autoloads (Singletons)

Register these in Project → Autoload:

| Name | Script | Purpose |
|------|--------|---------|
| `GameManager` | `game_manager.gd` | Scene transitions, run state, pause |
| `SaveManager` | `save_manager.gd` | Persistent save (meta-progression) |
| `AudioManager` | `audio_manager.gd` | Music crossfade, SFX pooling |
| `InputManager` | `input_manager.gd` | Remapped inputs, controller detection |
| `ElementDB` | `element_database.gd` | Element/combo definitions, lookup |

### 11.3 Data-Driven Design

**All element definitions, enemy stats, room templates, and loot tables must be defined as Godot Resource (.tres) files or JSON**, not hardcoded. This enables:
- Easy balancing without code changes
- Modding support in the future
- Claude Code can generate/modify data files independently from logic

**Element Resource Example:**
```gdscript
# element_data.gd (Resource script)
class_name ElementData
extends Resource

@export var id: String                    # "FIRE", "STEAM", etc.
@export var display_name: String
@export var tier: int                     # 0=base, 1=tier1 combo, 2=tier2, 3=tier3
@export var ingredients: Array[String]    # ["FIRE", "WATER"] for Steam
@export var color_primary: Color
@export var color_secondary: Color
@export var visual_tier_contribution: int # How much this element advances visual evolution
@export var abilities: Array[AbilityData] # 4 abilities per element
@export var ultimate: UltimateData        # Ultimate ability definition
@export var status_effect: String         # Primary status this element applies
@export var particle_scene: PackedScene   # Visual effect scene
```

### 11.4 Save System

**Meta-progression save file** (JSON, stored in `user://save_data.json`):
```json
{
  "version": 1,
  "echoes": 450,
  "unlocked_elements": ["FIRE", "WATER", "AIR", "EARTH"],
  "discovered_combinations": ["STEAM", "LIGHTNING", "MAGMA", "ICE"],
  "hub_structures": {
    "element_well_1": true,
    "armory_tier": 2,
    "stamina_forge_tier": 1,
    "alchemist_table": true,
    "cartographer_tower": false
  },
  "npcs_unlocked": ["keeper", "alchemist", "cartographer"],
  "lore_tablets_found": [1, 2, 3, 7, 12],
  "lore_tablet_26_unlocked": false,
  "most_used_element": "FIRE",
  "least_used_element": "DARK",
  "primordial_affinity": {"pyraxis": 0.35, "thalassa": 0.15, "ouranos": 0.20, "lithara": 0.10, "solenne": 0.10, "nythara": 0.10},
  "bestiary": ["stick_grunt", "ink_blob", "stone_golem"],
  "statistics": {
    "total_runs": 47,
    "highest_floor": 18,
    "total_enemies_killed": 3821,
    "total_combinations_performed": 156,
    "bosses_defeated": {"warden": 12, "drowned_king": 5, "tempest": 1},
    "total_echoes_earned": 1250,
    "total_play_time_seconds": 142680
  },
  "modifiers_active": [],
  "tower_cleared": false,
  "tutorial_complete": false,
  "total_runs_started": 5,
  "run_history_visuals": [
    {"elements": ["FIRE", "STEAM"], "visual_tier": 2},
    {"elements": ["LIGHTNING", "STORM", "AIR"], "visual_tier": 3},
    {"elements": ["EARTH"], "visual_tier": 1},
    {"elements": ["ICE", "WATER", "PERMAFROST"], "visual_tier": 3},
    {"elements": ["FIRE"], "visual_tier": 1}
  ]
}
```

**No in-run save.** The run is held in memory only. Quitting mid-run = death (the run is lost). This preserves permadeath integrity.

### 11.5 Performance Targets

| Metric | Target |
|--------|--------|
| FPS | 60 FPS minimum on mid-range hardware (GTX 1660 / RX 580 equivalent) |
| Load time (floor transition) | < 2 seconds |
| Load time (initial boot to hub) | < 5 seconds |
| Memory | < 2 GB RAM |
| Max simultaneous entities | 50 enemies + player + projectiles/effects |
| Particle budget per frame | 500 particles |

### 11.6 Steam Integration

- **Steam Achievements:** Map to meta-progression milestones (first boss kill, first tower clear, discover all Tier 1 combos, etc.)
- **Steam Cloud Save:** Sync `save_data.json` via Steam Cloud
- **Rich Presence:** Show current floor, zone, and active elements in Steam friends list
- **Trading Cards:** Optional, design later
- **Leaderboards:** Time-to-clear and highest floor with modifier sets

---

## 12. IMPLEMENTATION PRIORITY ORDER

This section defines the order in which systems should be built. Each phase produces a **playable milestone**.

### Phase 1 — Gray Box (Target: Playable Prototype)
1. Player movement (isometric 8-direction + dodge roll) in a single room
2. Base stick figure with light attack / heavy attack / dodge
3. Single enemy type (Stick Grunt) with chase + attack AI
4. Room loading (single static room → kill all enemies → door opens → next room)
5. HP / Stamina system
6. Death → restart loop
7. Basic HUD (HP bar, stamina bar)

**Milestone:** Player can move through 3 rooms, fight basic enemies, die, and restart.

### Phase 2 — Element Foundation
1. Element data system (Resource-based)
2. Fire element implementation (4 abilities)
3. Water element implementation (4 abilities)
4. Element Shrine room event (pick up element)
5. Ability slot UI
6. Steam combination (Fire+Water) via Combination Altar
7. Visual tier 0→1 transition when first element acquired

**Milestone:** Player can acquire Fire or Water, combine into Steam, and see visual changes.

### Phase 3 — Combat Depth
1. Remaining 4 base elements (Air, Earth, Light, Dark)
2. All Tier 1 combinations (15 total)
3. Status effect system
4. Combo reaction system
5. Damage types and resistance system
6. Ultimate ability framework (charge meter system supporting all 7 charge types, activation type handler)
7. Base element ultimates (6) and Tier 1 ultimates (15)
8. Ultimate charge HUD element
9. Enemy variety: one of each category (Fodder, Bruiser, Ranged, Mobile, Support)
10. Elite enemy variant system

**Milestone:** Full elemental combat with status effects, combo reactions, and ultimates.

### Phase 4 — Tower Structure
1. Zone randomization system (select 4 of 6 elements, assign to positions, pick biome variants)
2. Tutorial mode (fixed zone order for first 3 runs, flag in save data)
3. Procedural floor generator (room sequence with branching, rooms drawn from biome variant pools)
4. Implement 2 biome variants per element (12 total) as initial set — enough for variety, expand in Phase 8
5. Biome-specific hazard systems (per §5.1.1)
6. Floor-by-floor difficulty scaling tied to zone position
7. All room event types (Shrine with element weighting, Altar, Merchant, Rest, Challenge, Lore, Gambler)
8. Essence currency and merchant system
9. Consumable item system
10. Minimap

**Milestone:** Full 25-floor tower run is structurally completable with randomized zone elements and biomes.

### Phase 5 — Bosses and Element Identity
1. Boss generation system (select creature form from element's Titan pool per §5.3)
2. Implement 2 boss creature forms per element (12 bosses total as initial set — expand to full 36 in Phase 8)
3. Boss phase mechanics and signature mechanics per creature form
4. Boss difficulty scaling by zone position (same creature form is harder in Zone 4 than Zone 1)
5. Element-based enemy rosters (5 enemies per element × 6 elements + Apex exclusives = 35 enemies)
6. Zone-specific environmental hazard interactions (element hazards + biome hazards)
7. Boss HP bars and phase transition UI
8. The Convergence (Zone 5 boss) — adaptive mirror-construct
9. Zone music tracks (placeholder acceptable, one per element + Apex)

**Milestone:** Complete tower run with randomized elemental zones, creature-form bosses, and element-matched enemy rosters.

### Phase 6 — Meta-Progression and Narrative
1. Echoes earning system
2. Hub (Bastion) scene with structure placement
3. All hub structures and upgrade tiers
4. NPC system (unlock conditions, dialogue trees per §1B.6)
5. Lore Tablet system (25 tablets + dynamic personalization for tablets 12 and 16, see §1B.7)
6. Primordial ambient voice line system (whispered triggers at Shrines/Altars/boss antechambers, see §1B.9)
7. Codex (bestiary, recipes, lore tablet viewer with chronological reordering, Primordial Notes)
8. Save/Load system for meta-progression (including most/least used element tracking, Primordial affinity)
9. Run Summary screen
10. Convergence boss narrative integration (mirror-construct from run history, post-defeat summit sequence, see §1B.8)
11. Narrative tone shifts based on meta-milestones (§1B.9)
12. Secret Lore Tablet 26 (post-all-modifiers-clear reward)

**Milestone:** Full meta-progression loop with narrative arc — run tower, earn Echoes, upgrade hub, discover lore, hear Primordials, run again with deepening story context.

### Phase 7 — Visual Evolution and Creature Forms
1. Elemental weight calculation system (§2.3)
2. Stick figure → creature form morph animation system
3. 6 single-element dominant creature forms (Efreet, Leviathan-kin, Zephyr, Golem, Seraph, Wraith) at Tiers 1–4
4. 15 dual-element creature forms (Phoenix, Salamander, Djinn, etc.) at Tiers 1–4
5. Balanced human form at Tiers 1–4
6. Mid-run creature transition animations (smooth morph between forms when elements change)
7. Particle effect overlays for all elements
8. Hub character rendering from 10-run averaged weights
9. Environment destruction effects
10. Combo reaction visual effects

**Milestone:** Character visually evolves into distinct creature forms throughout a run based on build. Hub character reflects play history.

**Art Note:** This phase has the largest asset requirement in the project. Creature forms break down as:
- 6 single-element dominant forms
- 15 dual-element default forms
- ~10 Tier 1 combo-specific override forms (Ooze, Arachnid, Centaur, Wendigo, Fungal Horror, Thunderbird, etc.)
- ~10 Tier 2 combo-specific override forms (Jellyfish, Living Armor, Mammoth, Slime, Tardigrade, Tesseract, etc.)
- 1 balanced human form
- **Total: ~42 creature forms × 5 visual tiers = ~210 character visual states**
- Each needs 10 body-category-specific animation sets (bipedal, quadruped, serpentine, arachnid, avian, amorphous, floating, arthropod, geometric, insectoid)

**Scope reduction strategies:**
- Phase 7a: Implement Tier 0 (stick figure) + Tier 3–4 only (skip Tier 1–2, use interpolation)
- Phase 7b: Implement single-element + human forms first. Add dual-element defaults second. Add combo-specific overrides last.
- **Shared rigs by body category** (§2.3.6): All quadrupeds share a rig. All serpentine forms share a rig. All amorphous forms share a rig. This reduces unique rig count from 42 to 10.
- Forms without a specific override use the dual-element default, reducing the number of "must-have" unique forms

### Phase 8 — Tier 2, Tier 3, Content Expansion, and Endgame
1. All Tier 2 combinations and their ultimates (16)
2. All Tier 3 (Ultimate Element) combinations and their ultimates (7)
3. Stick Figure secret ultimate (Blank Canvas)
4. Remaining biome variants (expand from 12 to all 36 — 4 additional variants per element)
5. Remaining boss creature forms (expand from 12 to all 36 — 4 additional Titans per element)
6. New Game+ modifier system
7. The Wanderer NPC and post-clear content
8. Shortcut Gate system
9. Achievement integration
10. Full accessibility options

**Milestone:** Complete game with all content (36 biomes, 36 bosses, all combinations), post-game, and accessibility.

### Phase 9 — Polish
1. Final art pass (all tilesets, sprites, effects)
2. Full audio implementation (music, SFX, ambient per zone)
3. Screen transitions and juice (screen shake, hit pause, particles)
4. Balance pass (enemy HP/damage tuning, element ability damage, Echo economy)
5. Performance optimization
6. Steam integration (achievements, cloud save, rich presence)
7. Bug fixing and playtesting

**Milestone:** Ship-ready early access / beta build.

---

## 13. OPEN DESIGN QUESTIONS

These items are intentionally unresolved and should be playtested before finalizing:

1. **Element slot count:** 4 slots may be too restrictive or too generous. Playtest with 3 and 5 as alternatives.
2. **Combination Altar frequency:** 1 guaranteed per 3 floors may need tuning. If players consistently can't find altars to combine, increase frequency.
3. **Tier 3 balance:** Ultimate elements may be so powerful they trivialize floors 21–25. Consider requiring a drawback or resource cost to maintain Tier 3.
4. **Run length:** 25 floors at 2–3 hours may cause fatigue. Consider whether 20 floors with denser content per floor is better.
5. **Hub scaling:** The Armory's +50 HP over 5 tiers may make early floors too easy after extensive meta-progression. Ensure scaling remains meaningful without trivializing early content.
6. **Visual readability and creature forms:** The creature form system produces ~42 distinct character silhouettes across 10 body categories, each at 5 visual tiers. Shared rigs reduce animation workload, but the sheer variety means: (a) every form needs to read clearly at isometric combat scale, (b) the Ooze/Slime amorphous forms need special attention to ensure attacks are readable when the character has no defined limbs, (c) the Tesseract's screen distortion effect must not interfere with gameplay readability.
7. **Controller feel:** Isometric real-time combat with 4 ability buttons + dodge + light/heavy attack + ultimate is a lot of inputs. Ensure controller mapping feels natural. Consider aim-assist for abilities. LB+RB for ultimate activation should feel deliberate without being clunky.
8. **Ultimate charge tuning:** The 7 different charge types need independent balance passes. Kill Streak ultimates (especially Singularity at 10 kills) may be too hard to trigger in low-density rooms. HP Threshold ultimates may be oppressively strong if the player can hover at low HP reliably. Timed Buildup may feel too passive. Each charge type needs playtesting in isolation.
9. **Tier 3 ultimate power level:** Tier 3 ultimates are designed to feel godlike, but they shouldn't trivialize the final zone. The charge requirements should be tuned so Tier 3 ultimates fire ~2-3 times per floor at most, not every room.
10. **Secret ultimate (Blank Canvas) difficulty:** Reaching Floor 10 with zero elements is designed to be near-impossible. If playtesters can do it consistently, the trigger condition needs to be harder (Floor 15?). If nobody can do it, consider Floor 7.
11. **Body category balance:** The mechanical differences between body categories (§2.3.6) are the deepest balance challenge in the game. Key tensions to playtest: (a) Arthropod's +40% HP and knockback immunity may make it the obvious "safe" pick for new players, reducing build diversity. (b) Avian's ground hazard immunity trivializes certain biome variants (Caldera, Root Network). (c) Amorphous +20% HP AND halved status durations AND damage-to-Essence conversion may be overloaded — consider removing one. (d) Moth's -20% HP may be too punishing given its small hitbox already provides survivability. (e) Mid-run form transitions that change max HP could feel bad if the player loses HP buffer involuntarily (e.g., picking up an element for the abilities but not wanting the body change). Consider showing the projected form change at Element Shrines before the player commits.
12. **Form preview at shrines:** Element Shrines and Combination Altars should display what creature form the player will become if they accept, including the mechanical stat changes (HP, speed, hitbox, passive). This is critical information for meaningful choice — without it, players will feel blindsided by involuntary mechanical changes.

---

## APPENDIX A: GLOSSARY

| Term | Definition |
|------|-----------|
| **Blank Slate** | The player's starting state — a featureless stick figure |
| **Element** | A permanent run-duration ability modifier (Fire, Water, Steam, etc.) |
| **Chain Alchemy** | The combination system — elements combine into higher tiers |
| **Tier** (element) | 0=base, 1=two base elements combined, 2=tier 1 + base or tier 1 + tier 1, 3=ultimate |
| **Tier** (visual) | 0–4 scale of character visual complexity |
| **Creature Form** | The character's physical shape, determined by elemental weight balance and specific combinations held — from stick figure (Tier 0) through mythological creatures (element-dominant) or human warrior (balanced). Specific combos can override default forms (e.g., Mud → Ooze instead of Naga). |
| **Body Category** | The animation rig and mechanical profile for a creature form (bipedal, quadruped, serpentine, arachnid, avian, amorphous, floating, arthropod, geometric, insectoid). Determines movement speed, hitbox size, HP modifier, dodge behavior, passive ability, and sound design. |
| **Essence** | In-run currency, lost on death |
| **Echoes** | Meta-progression currency, kept on death. Narratively: residue of past attempts left on the Crucible's fabric. |
| **Bastion** | The persistent hub area between runs. Exists in liminal space between the expired old world and the unborn new one. |
| **Hub Echo** | The player character's visual appearance in Bastion, composited from the last 10 runs' element loadouts |
| **Primordials** | The six elemental forces that govern creation: Pyraxis (Fire), Thalassa (Water), Ouranos (Air), Lithara (Earth), Solenne (Light), Nythara (Dark). Not gods — forces. |
| **The Mold** | The narrative role of the player — the living template from which all life in the new world will be patterned. Whatever form the player takes at the summit becomes the seed-pattern for the new world. |
| **The Crucible** | The narrative name for the tower. A testing apparatus woven from raw creation-stuff by the Primordials. |
| **Codex** | Encyclopedia tracking discoveries (enemies, combos, lore) |
| **Modifier** | Post-clear difficulty/reward toggles |
| **Floor** | A single level of the tower (sequence of rooms + boss/elite) |
| **Zone** | A group of 5 thematically connected floors |
| **Run** | A single attempt at climbing the tower from floor 1 to 25 |
| **Ultimate** | A powerful build-defining ability separate from the 4 ability slots, gated by a charge mechanic that varies per ultimate |
| **Charge Type** | The method by which a specific ultimate's meter fills (Damage Dealt, Damage Taken, Combo Reactions, Kill Streak, Timed Buildup, HP Threshold, Elemental Saturation) |
| **Activation Type** | How an ultimate resolves when triggered (Instant, Transformation, Channel, Summon, Field, Sacrifice) |

## APPENDIX B: COMPLETE ABILITY REFERENCE

> **Note to implementer:** This section should be expanded into individual ability data files (.tres Resources) during Phase 2–3. Each ability needs: name, description, slot (1–4), damage, cooldown, range, AoE size, status effect applied, duration, stamina cost (if any), visual effect reference, audio effect reference. The tables in §4.3 provide the template; replicate for every element and combination.

## APPENDIX C: FULL COMBINATION CHAIN MAP

```
Base Elements:     FIRE   WATER   AIR   EARTH   LIGHT   DARK
                     \      |     /  \    |      /  \     |
Tier 1 (15):    Steam  Lightning  Magma  Solar  Hellfire  Ice  Mud  Purify  Poison  Sand  HolyWind  Void  Crystal  Decay  Eclipse
                     \         |          /     \         |           /
Tier 2 (16+):   MudGeyser  Superheated  Storm  Magnetic  Obsidian  VolcanicAsh  ThermalShock  Permafrost  ToxicFume  Antivenom  ShadowCrystal  Prism  Dimensional  Gravity  Supernova  TidalForce
                     \                    |                     /
Tier 3 (7):     Cataclysm   Entropy   Architect   Maelstrom   Singularity   Aurora   AbsoluteZero
```

Total unique elements: 6 + 15 + 16 + 7 = **44 elements**
Total unique ability sets: 44 × 4 = **176 abilities**
Total unique ultimates: 6 + 15 + 16 + 7 + 1 (secret) = **45 ultimates**
Total unique player abilities: **221**

---

*End of Game Design Document — Blank Slate v1.0*
