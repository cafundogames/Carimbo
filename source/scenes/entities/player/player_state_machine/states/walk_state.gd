class_name PlayerWalkState
extends PlayerState


func enter_state(player_node: PlayerCharacterBody3D) -> void:
	super(player_node)
	player.stampable_sprite.play(player.animation_walk)


func handle_physics_process(_delta: float) -> void:
	var direction: Vector2 = player.get_movement_vector()
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
	if Input.is_action_just_pressed(&"roll"):
		player.change_state(player.state_roll)
	if Input.is_action_pressed(&"hit"):
		player.change_state(player.state_attack)
