class_name EnemyDeadState
extends EnemyState

@export var death_sound: AudioStream
@export var stream_player: AudioStreamPlayer


func _ready() -> void:
	if not stream_player:
		stream_player = AudioStreamPlayer.new()
		add_child(stream_player)


func enter_state(actor: EnemyCharacterBody3D) -> void:
	super(actor)
	body.velocity = Vector3(0.0, actor.velocity.y, 0.0)
	stream_player.stream = death_sound
	stream_player.play()
	body.stampable_sprite.clear_viewport()
	body.stampable_sprite.play(body.animation_death)
	body.stampable_sprite.animation_finished.connect(
		body.stampable_sprite.trigger_burn_fx,
		CONNECT_ONE_SHOT,
	)
	body.stampable_sprite.burned.connect(body._on_sprite_burned, CONNECT_ONE_SHOT)


func exit_state() -> void:
	if body.stampable_sprite.burned.is_connected(body._on_sprite_burned):
		body.stampable_sprite.burned.disconnect(body._on_sprite_burned)
