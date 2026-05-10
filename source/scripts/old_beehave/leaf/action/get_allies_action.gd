@tool
class_name GetAlliesAction
extends ActionLeaf

const ALLIES_KEY = BeehaveConsts.ALLIES_KEY
const ALLIES_GROUP = BeehaveConsts.MONSTER_NODE_GROUP


func tick(_actor: Node, blackboard: Blackboard) -> int:
	var allies: Array[EnemyCharacter] = []
	allies.assign(blackboard.get_value(ALLIES_KEY,
		get_tree().get_nodes_in_group(ALLIES_GROUP)\
		.filter(func(c: Node) -> bool:
			return c is EnemyCharacter and (c as EnemyCharacter).stats_component)))
	blackboard.set_value(ALLIES_KEY, allies)
	return SUCCESS
