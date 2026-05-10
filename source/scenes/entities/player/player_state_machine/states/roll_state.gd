class_name PlayerRollState
extends PlayerState

@export var roll_amount: float = 30.0
@export_range(0.1, 2.0, 0.1, "suffix:s") var roll_time: float = 0.3
@export var hurtbox: Hurtbox3D

var _time_left: float


func enter_state(player_node: PlayerCharacterBody3D) -> void:
	_time_left = roll_time
	super(player_node)
	if not player.is_on_floor():
		player.change_state(player.state_idle)
		return
	player.velocity = Vector3(
		player.input_dir.x,
		0.0,
		player.input_dir.y,
	) * roll_amount
	player.stampable_sprite.play(player.animation_roll)
	if hurtbox:
		hurtbox.set_deferred(&"monitoring", false)


func exit_state() -> void:
	if hurtbox:
		hurtbox.set_deferred(&"monitoring", true)


func handle_physics_process(delta: float) -> void:
	if player.global_position.y <= player.death_on_y:
		player.change_state(player.state_dead)
	if Input.is_action_just_pressed(&"hit"):
		player.change_state(player.state_attack)
	_time_left -= delta
	if not is_zero_approx(_time_left):
		return
	player.change_state(player.state_walk)
