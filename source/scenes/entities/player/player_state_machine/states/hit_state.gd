class_name PlayerHitState
extends PlayerState

@export var hit_sound: AudioStream
@export var stream_player: AudioStreamPlayer
@export var stun_time: float = 0.5

var _stun_time: float


func _ready() -> void:
	if not stream_player:
		stream_player = AudioStreamPlayer.new()
		add_child(stream_player)


func enter_state(player_node: PlayerCharacterBody3D) -> void:
	_stun_time = stun_time
	super(player_node)
	player.velocity.x = 0.0
	player.velocity.z = 0.0
	player.stampable_sprite.play(player.animation_hit)
	stream_player.stream = hit_sound
	stream_player.play()
	player.stampable_sprite.animation_finished.connect(
		player.change_state.bind(player.state_idle),
		CONNECT_ONE_SHOT,
	)


func exit_state() -> void:
	if player.stampable_sprite.animation_finished.is_connected(player.change_state):
		player.stampable_sprite.animation_finished.disconnect(player.change_state)


func handle_physics_process(delta: float) -> void:
	if player.global_position.y <= player.death_on_y:
		player.change_state(player.state_dead)
	if _stun_time > 0.0:
		_stun_time -= delta
		return
	if not Input.get_vector(
		&"move_left",
		&"move_right",
		&"move_fowards",
		&"move_backwards",
	).is_zero_approx():
		player.change_state(player.state_walk)
	if Input.is_action_pressed(&"roll"):
		player.change_state(player.state_roll)
