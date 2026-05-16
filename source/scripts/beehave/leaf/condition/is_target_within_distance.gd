@tool
class_name IsTargetWithinDistance
extends ConditionLeaf

@export var blackboard_key: StringName = "target_node"
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var scan_range: float = 2.0


func tick(actor: Node, blackboard: Blackboard) -> int:
	var actor_id: String = str(actor.get_instance_id())
	var target_node: Node3D = blackboard.get_value(blackboard_key, null, actor_id)
	if not target_node:
		return FAILURE
	var dis: float = target_node.global_position.distance_to((actor as Node3D).global_position)
	if dis > scan_range:
		return FAILURE
	return SUCCESS
