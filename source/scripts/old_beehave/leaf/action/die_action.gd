@tool
class_name DieAction
extends ActionLeaf

@export var stats_component: StatsComponent:
	set(v): stats_component = v; update_configuration_warnings()

func tick(_actor: Node, _blackboard: Blackboard) -> int:
	if not stats_component: return FAILURE
	stats_component.kill()
	return SUCCESS


func _get_configuration_warnings() -> PackedStringArray:
	var war: PackedStringArray = super._get_configuration_warnings()
	if not stats_component:
		war.append("This action leaf requires an StatsComponent")
	return war
