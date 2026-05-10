@tool
class_name WaitForRangeCondition
extends ConditionLeaf

const TARGET_KEY = BeehaveConsts.TARGET_POS_KEY

@export_range(0.5, 100.0, 0.1, "suffix:m", "or_greater") var _range: float = 1.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	var target: Vector3 = blackboard.get_value(TARGET_KEY)
	if not target: return FAILURE
	if (actor as Node3D).global_position.distance_to(target) <= _range: return SUCCESS
	return RUNNING
