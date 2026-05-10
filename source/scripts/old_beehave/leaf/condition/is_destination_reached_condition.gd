@tool
class_name IsDestinationReachedCondition
extends ConditionLeaf


@export var input_component: InputComponent:
	set(v): input_component = v; update_configuration_warnings()


func tick(_actor: Node, _blackboard: Blackboard) -> int:
	return SUCCESS if input_component.is_at_destination() else FAILURE


func interrupt(_actor: Node, _blackboard: Blackboard) -> void:
	input_component.stop_navigation()


func _get_configuration_warnings() -> PackedStringArray:
	var war: PackedStringArray = super._get_configuration_warnings()
	if not input_component:
		war.append("This action leaf requires an InputComponent")
	return war
