@tool
class_name ResetMoveSpeedAction
extends ActionLeaf

const MOVE_SPEED_KEY = BeehaveConsts.MOVE_SPEED_KEY

@export var move_component: MoveComponent:
	set(v): move_component = v; update_configuration_warnings()


func tick(_actor: Node, blackboard: Blackboard) -> int:
	move_component.speed = blackboard.get_value(MOVE_SPEED_KEY, 10.0)
	return SUCCESS


func _get_configuration_warnings() -> PackedStringArray:
	var war: PackedStringArray = super._get_configuration_warnings()
	if not move_component:
		war.append("This action leaf requires an MoveComponent")
	return war
