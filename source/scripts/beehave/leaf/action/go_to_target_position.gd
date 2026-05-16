@tool
class_name GoToTargetPosition
extends ActionLeaf

@export var navigation_agent: NavigationAgent3D
@export var target_position_key: StringName = "target_position"


func tick(actor: Node, blackboard: Blackboard) -> int:
	var actor_id: String = str(actor.get_instance_id())
	var cached_position: Vector3 = blackboard.get_value(
		target_position_key,
		(actor as Node3D).global_position,
		actor_id,
	)

	assert(actor is CharacterBody3D, "[code]actor[/code] must extend CharacterBody3D")
	var body: EnemyCharacterBody3D = actor
	if not body.is_on_floor():
		body.velocity = Vector3(0.0, body.velocity.y, 0.0)
		return FAILURE

	assert(navigation_agent != null, "NavigationAgent3D must not be null!")
	navigation_agent.target_position = cached_position
	var next_path_position = navigation_agent.get_next_path_position()

	if navigation_agent.is_navigation_finished():
		return SUCCESS

	var new_velocity = body.global_position.direction_to(next_path_position) * body.movement_speed
	var velocity = Vector3(
		new_velocity.x,
		body.velocity.y,
		new_velocity.z,
	)
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(velocity)
	else:
		body.velocity = velocity
	return RUNNING


func interrupt(actor: Node, _blackboard: Blackboard) -> void:
	if not navigation_agent:
		return
	navigation_agent.target_position = (actor as Node3D).global_position
	navigation_agent.get_next_path_position()
	assert(actor is CharacterBody3D, "[code]actor[/code] must extend CharacterBody3D")
	var body: CharacterBody3D = actor
	var new_velocity = Vector3(0.0, body.velocity.y, 0.0)
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		body.velocity = new_velocity
