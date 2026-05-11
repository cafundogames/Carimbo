@tool
class_name GetRandomPositionInRadius
extends ActionLeaf

@export_range(0.1, 30.0, 0.1, "suffix:m") var max_radius: float = 10.0
@export var target_position_key: String = "target_position"


func tick(actor: Node, blackboard: Blackboard) -> int:
	var actor_id: String = str(actor.get_instance_id())

	var radius: float = max_radius * sqrt(randf())
	var angle: float = randf() * TAU
	var position: Vector3 = Vector3(
		radius * cos(angle),
		0.0,
		radius * sin(angle),
	)
	if actor is Node3D:
		position += (actor as Node3D).global_position
	blackboard.set_value(target_position_key, position, actor_id)
	return SUCCESS
