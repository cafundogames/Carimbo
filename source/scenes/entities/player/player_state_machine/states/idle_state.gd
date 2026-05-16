class_name PlayerIdleState
extends PlayerState


func enter_state(player_node: PlayerCharacterBody3D) -> void:
	super(player_node)
	player.velocity.x = 0.0
	player.velocity.z = 0.0
	player.stampable_sprite.play(player.animation_idle)


func handle_physics_process(_delta: float) -> void:
	if not player.get_movement_vector().is_zero_approx():
		player.change_state(player.state_walk)
	if Input.is_action_just_pressed(&"roll"):
		player.change_state(player.state_roll)
	if Input.is_action_pressed(&"hit"):
		player.change_state(player.state_attack)
