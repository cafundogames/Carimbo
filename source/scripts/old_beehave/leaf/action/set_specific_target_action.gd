@tool
class_name SetSpecificTargetAction
extends ActionLeaf

const TARGET_KEY = BeehaveConsts.TARGET_POS_KEY

@export var target: Vector3
@export var input_component: InputComponent:
	set(v): input_component = v; update_configuration_warnings()

func tick(_actor: Node, blackboard: Blackboard) -> int:
	blackboard.set_value(TARGET_KEY, target)
	input_component.set_target_pos(target)
	return SUCCESS


func _get_configuration_warnings() -> PackedStringArray:
	var war: PackedStringArray = super._get_configuration_warnings()
	if not input_component:
		war.append("This action leaf requires an InputComponent")
	return war
