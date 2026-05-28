class_name PlayerAttackState
extends PlayerState

const COMMON_STAMP = preload("uid://cxewxkqw1lx35")

@export var noise_emitter: PhantomCameraNoiseEmitter3D
@export var audio_player: AudioStreamPlayer

var hit_cooldown: float = 0.5
var _time_left: float


func enter_state(player_node: PlayerCharacterBody3D) -> void:
	super(player_node)
	var curr_stamp: StampData = player.current_stamp if player.current_stamp else COMMON_STAMP
	hit_cooldown = curr_stamp.stamp_cooldown
	_time_left = hit_cooldown
	player.velocity = Vector3.DOWN * player.velocity.y
	player.stampable_sprite.stop()
	var animation: StringName
	match curr_stamp.stamp_type:
		StampData.ATTACK_MELEE:
			animation = player.animation_attk
		StampData.ATTACK_RANGED:
			animation = player.animation_fire
	player.stampable_sprite.play(animation)
	_spawn_stamp(curr_stamp.stamp_scene)
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
		player.change_state(self)

	if Input.is_action_just_pressed(&"roll"):
		player.change_state(player.state_roll)
	if not player.stampable_sprite.is_playing():
		player.change_state(player.state_idle)


func _spawn_stamp(stamp_scene: PackedScene) -> void:
	var stamp: Node3D = stamp_scene.instantiate()
	add_child(stamp)
	stamp.look_at_from_position(
		player.global_position,
		player.global_position + Vector3(player.input_dir.x, 0.0, player.input_dir.y),
	)
