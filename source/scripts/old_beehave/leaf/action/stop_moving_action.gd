@tool
class_name StopMovingAction
extends ActionLeaf

@export var input_component: InputComponent: set = _set_input_component


func tick(_actor: Node, _blackboard: Blackboard) -> int:
	input_component.set_horizontal_input_direction(Vector2.ZERO)
	return FAILURE if input_component.blocked else SUCCESS


func _get_configuration_warnings() -> PackedStringArray:
	var war: PackedStringArray = super._get_configuration_warnings()
	if not input_component:
		war.append("This action leaf requires an InputComponent")
	return war


func _set_input_component(value: InputComponent) -> void:
	input_component = value
	update_configuration_warnings()
