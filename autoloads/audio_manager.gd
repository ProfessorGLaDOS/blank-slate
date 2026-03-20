extends Node

const SFX_POOL_SIZE: int = 16

var _music_a: AudioStreamPlayer
var _music_b: AudioStreamPlayer
var _active_player: AudioStreamPlayer
var _sfx_pool: Array[AudioStreamPlayer2D] = []
var _sfx_index: int = 0


func _ready() -> void:
	_music_a = AudioStreamPlayer.new()
	_music_a.name = "MusicA"
	_music_a.bus = "Music"
	add_child(_music_a)

	_music_b = AudioStreamPlayer.new()
	_music_b.name = "MusicB"
	_music_b.bus = "Music"
	add_child(_music_b)

	_active_player = _music_a

	for i in range(SFX_POOL_SIZE):
		var sfx_player := AudioStreamPlayer2D.new()
		sfx_player.name = "SFX_" + str(i)
		sfx_player.bus = "SFX"
		add_child(sfx_player)
		_sfx_pool.append(sfx_player)


func crossfade_to(stream: AudioStream, duration: float = 2.0) -> void:
	var fade_out_player: AudioStreamPlayer = _active_player
	var fade_in_player: AudioStreamPlayer

	if _active_player == _music_a:
		fade_in_player = _music_b
	else:
		fade_in_player = _music_a

	fade_in_player.stream = stream
	fade_in_player.volume_db = -80.0
	fade_in_player.play()

	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(fade_out_player, "volume_db", -80.0, duration)
	tween.tween_property(fade_in_player, "volume_db", 0.0, duration)
	tween.set_parallel(false)
	tween.tween_callback(fade_out_player.stop)

	_active_player = fade_in_player


func play_sfx(stream: AudioStream, position: Vector2, volume_db: float = 0.0, pitch: float = 1.0) -> void:
	var player: AudioStreamPlayer2D = _sfx_pool[_sfx_index]
	player.stream = stream
	player.global_position = position
	player.volume_db = volume_db
	player.pitch_scale = pitch
	player.play()

	_sfx_index = (_sfx_index + 1) % SFX_POOL_SIZE
