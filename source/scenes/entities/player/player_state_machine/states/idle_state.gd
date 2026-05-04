class_name PlayerIdleState
extends PlayerState


func enter_state(player_node: PlayerCharacterBody3D) -> void:
	super(player_node)
	player.velocity.x = 0.0
	player.velocity.z = 0.0
	player.stampable_sprite.play(player.animation_idle)


func handle_physics_process(_delta: float) -> void:
	if player.global_position.y <= player.death_on_y:
		player.change_state(player.state_dead)
	if not Input.get_vector(
		&"move_left",
		&"move_right",
		&"move_fowards",
		&"move_backwards",
	).is_zero_approx():
		player.change_state(player.state_walk)
	if Input.is_action_pressed(&"roll"):
		player.change_state(player.state_roll)
