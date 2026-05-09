class_name EnemyHitState
extends EnemyState

@export var hit_sound: AudioStream
@export var stream_player: AudioStreamPlayer
@export var stun_time: float = 0.5

var _stun_time: float


func _ready() -> void:
	if not stream_player:
		stream_player = AudioStreamPlayer.new()
		add_child(stream_player)


func enter_state(actor: EnemyCharacterBody3D) -> void:
	_stun_time = stun_time
	super(actor)
	body.velocity = Vector3(0.0, body.velocity.y, 0.0)
	body.stampable_sprite.play(body.animation_hit)
	stream_player.stream = hit_sound
	stream_player.play()
	body.stampable_sprite.animation_finished.connect(
		body.change_state.bind(body.state_beehave),
		CONNECT_ONE_SHOT,
	)


func exit_state() -> void:
	if body.stampable_sprite.animation_finished.is_connected(body.change_state):
		body.stampable_sprite.animation_finished.disconnect(body.change_state)


func handle_physics_process(delta: float) -> void:
	if body.global_position.y <= body.death_on_y:
		body.change_state(body.state_dead)
	if _stun_time > 0.0:
		_stun_time -= delta
		return
	body.change_state(body.state_beehave)
