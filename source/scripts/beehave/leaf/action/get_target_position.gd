@tool
class_name GetTargetPosition
extends ActionLeaf

@export var target_node_key: StringName = "target_node"
@export var target_position_key: StringName = "target_position"


func tick(actor: Node, blackboard: Blackboard) -> int:
	var actor_id: String = str(actor.get_instance_id())
	var target_node: Node3D = blackboard.get_value(target_node_key, null, actor_id)
	if not target_node:
		return FAILURE
	var position: Vector3 = target_node.global_position
	blackboard.set_value(target_position_key, position, actor_id)
	return SUCCESS
