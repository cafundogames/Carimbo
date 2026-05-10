@tool
class_name SetTargetDirectionAction
extends ActionLeaf

const TARGET_KEY = BeehaveConsts.TARGET_POS_KEY

@export var input_component: InputComponent:
	set(v): input_component = v; update_configuration_warnings()


func tick(actor: Node, blackboard: Blackboard) -> int:
	var target: Vector3 = blackboard.get_value(TARGET_KEY)
	var dir: Vector3 = (actor as Node3D).global_position.direction_to(target)
	input_component.set_input_direction(dir)
	return SUCCESS


func _get_configuration_warnings() -> PackedStringArray:
	var war: PackedStringArray = super._get_configuration_warnings()
	if not input_component:
		war.append("This action leaf requires an InputComponent")
	return war
