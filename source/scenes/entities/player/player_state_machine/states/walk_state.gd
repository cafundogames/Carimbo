class_name PlayerWalkState
extends PlayerState


func enter_state(player_node: PlayerCharacterBody3D) -> void:
	super(player_node)
	player.stampable_sprite.play(player.animation_walk)


func handle_physics_process(_delta: float) -> void:
	if player.global_position.y <= player.death_on_y:
		player.change_state(player.state_dead)
	var direction: Vector2 = Input.get_vector(
		&"move_left",
		&"move_right",
		&"move_fowards",
		&"move_backwards",
	)
	if direction.is_zero_approx():
		player.change_state(player.state_idle)
	else:
		player.input_dir = direction
		direction *= player.movement_speed
		player.velocity = Vector3(
			direction.x,
			player.velocity.y,
			direction.y,
		)
	if Input.is_action_pressed(&"roll"):
		player.change_state(player.state_roll)
