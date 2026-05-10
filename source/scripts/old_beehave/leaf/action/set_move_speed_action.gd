@tool
class_name SetMoveSpeedAction
extends ActionLeaf

const MOVE_SPEED_KEY = BeehaveConsts.MOVE_SPEED_KEY

@export_range(0.1, 100.0, 0.1) var speed: float = 10.0
@export var move_component: MoveComponent:
	set(v): move_component = v; update_configuration_warnings()


func tick(_actor: Node, blackboard: Blackboard) -> int:
	if not blackboard.has_value(MOVE_SPEED_KEY):
		blackboard.set_value(MOVE_SPEED_KEY, move_component.speed)
	move_component.speed = speed
	return SUCCESS


func _get_configuration_warnings() -> PackedStringArray:
	var war: PackedStringArray = super._get_configuration_warnings()
	if not move_component:
		war.append("This action leaf requires an MoveComponent")
	return war
