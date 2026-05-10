@tool
class_name GetEnemyAction
extends ActionLeaf

const TARGET_KEY = BeehaveConsts.TARGET_KEY
const TARGET_POS_KEY = BeehaveConsts.TARGET_POS_KEY

func tick(_actor: Node, blackboard: Blackboard) -> int:
	var target: Node3D = blackboard.get_value(TARGET_KEY,
		get_tree().get_first_node_in_group(BeehaveConsts.PLAYER_NODE_GROUP))
	blackboard.set_value(TARGET_KEY, target)
	blackboard.set_value(TARGET_POS_KEY, target.global_position)
	return SUCCESS
