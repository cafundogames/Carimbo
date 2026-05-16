@tool
class_name HealDocsShield
extends ActionLeaf

@export var blackboard_key: StringName = "target_node"
@export var heal_amount: float = 1.0
@export var heal_max_amount: float = 1.0


func tick(actor: Node, blackboard: Blackboard) -> int:
	var actor_id: String = str(actor.get_instance_id())
	var node: Node3D = blackboard.get_value(blackboard_key, null, actor_id)
	if not node or node is not EnemyCharacterBody3D:
		return FAILURE
	var document: EnemyCharacterBody3D = node
	if document.shield_data == null or document.shield_data.shield >= heal_max_amount:
		return FAILURE
	document.shield_data.heal(heal_amount)
	return SUCCESS
