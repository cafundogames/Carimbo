class_name PlayerDeadState
extends PlayerState

@export var death_sound: AudioStream
@export var stream_player: AudioStreamPlayer


func _ready() -> void:
	if not stream_player:
		stream_player = AudioStreamPlayer.new()
		add_child(stream_player)


func enter_state(player_node: PlayerCharacterBody3D) -> void:
	super(player_node)
	player.velocity.x = 0.0
	player.velocity.z = 0.0
	stream_player.stream = death_sound
	stream_player.play()
	player.stampable_sprite.play(player.animation_death_start)
	await player.stampable_sprite.animation_finished
	player.stampable_sprite.clear_viewport()
	player.stampable_sprite.play(player.animation_death_loop)
	await player.stampable_sprite.animation_looped
	player.stampable_sprite.trigger_burn_fx()
