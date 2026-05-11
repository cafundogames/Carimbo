@tool
class_name HealDocsShield
extends ActionLeaf

@export var blackboard_key: StringName = "target"
@export var heal_amount: float = 1.0


func tick(_actor: Node, blackboard: Blackboard) -> int:
	var node: Node3D = blackboard.get_value(blackboard_key)
	if not node or node is not EnemyCharacterBody3D:
		return FAILURE
	var document: EnemyCharacterBody3D = node
	if document.shield_data == null:
		return FAILURE
	document.shield_data.heal(heal_amount)
	return SUCCESS
