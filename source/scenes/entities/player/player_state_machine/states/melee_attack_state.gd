class_name PlayerMeleeAttackState
extends PlayerState

@export var hit_cooldown: float = 0.5
@export var noise_emitter: PhantomCameraNoiseEmitter3D
@export var audio_player: AudioStreamPlayer

var _time_left: float


func enter_state(player_node: PlayerCharacterBody3D) -> void:
	_time_left = hit_cooldown
	super(player_node)
	player.velocity.x = 0.0
	player.velocity.z = 0.0
	# TODO: when runes are available, use its info to get the animation speed for the attack
	player.stampable_sprite.stop()
	var anim_speed: float = 1.0
	player.stampable_sprite.play(player.animation_attk, anim_speed)
	if audio_player:
		audio_player.play()


func exit_state() -> void:
	if player.stampable_sprite.animation_finished.is_connected(player.change_state):
		player.stampable_sprite.animation_finished.disconnect(player.change_state)


func handle_physics_process(delta: float) -> void:
	if _time_left < (hit_cooldown / 2.0) and noise_emitter:
		noise_emitter.emit()
	if _time_left > 0.0:
		_time_left -= delta
	elif Input.is_action_pressed(&"hit"):
		# TODO: when runes are available, use its info to select between melee or ranged
		var new_attack: PlayerState = player.state_attack_melee
		player.change_state(new_attack)

	if Input.is_action_pressed(&"roll"):
		player.change_state(player.state_roll)
	if not player.stampable_sprite.is_playing():
		player.change_state(player.state_idle)
