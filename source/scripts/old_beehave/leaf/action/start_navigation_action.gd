@tool
class_name StartNavigationAction
extends ActionLeaf

@export var input_component: InputComponent:
	set(v): input_component = v; update_configuration_warnings()
@export var navigation_agent: NavigationAgent3D:
	set(v): navigation_agent = v; update_configuration_warnings()


func tick(actor: Node, _blackboard: Blackboard) -> int:
	input_component.start_navigation(navigation_agent, (actor as Node3D).global_position)
	return SUCCESS


func _get_configuration_warnings() -> PackedStringArray:
	var war: PackedStringArray = super._get_configuration_warnings()
	if not input_component:
		war.append("This action leaf requires an InputComponent")
	if not navigation_agent:
		war.append("This action leaf requires an NavigationAgent3D")
	return war


func interrupt(_actor: Node, _blackboard: Blackboard) -> void:
	input_component.stop_navigation()
