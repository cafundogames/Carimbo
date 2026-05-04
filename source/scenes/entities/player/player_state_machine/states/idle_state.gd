class_name PlayerIdleState
extends PlayerState


func enter_state(player_node: PlayerCharacterBody3D) -> void:
	super(player_node)
	player.velocity = Vector3.ZERO


func handle_input(_event: InputEvent) -> void:
	pass


func handle_physics_process(_delta: float) -> void:
	pass
