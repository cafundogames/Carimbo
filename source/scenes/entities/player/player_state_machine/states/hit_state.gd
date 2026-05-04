class_name PlayerHitState
extends PlayerState

@export var hit_sound: AudioStream
@export var stream_player: AudioStreamPlayer


func _ready() -> void:
	if not stream_player:
		stream_player = AudioStreamPlayer.new()
		add_child(stream_player)


func enter_state(player_node: PlayerCharacterBody3D) -> void:
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
