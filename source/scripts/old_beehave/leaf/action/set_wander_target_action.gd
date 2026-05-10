@tool
class_name SetWanderTargetAction
extends ActionLeaf

const TARGET_POS_KEY = BeehaveConsts.TARGET_POS_KEY

@export_range(0.1, 100.0, 0.1, "suffix:m", "or_greater") var wander_range: float = 10.0
@export var input_component: InputComponent:
	set(v): input_component = v; update_configuration_warnings()

func tick(actor: Node, blackboard: Blackboard) -> int:
	var r: float = wander_range * sqrt(randf())
	var theta: float = randf() * TAU
	var a: Node3D = actor
	var position: Vector3 = Vector3(
		a.global_position.x + r * cos(theta),
		a.global_position.y,
		a.global_position.z + r * sin(theta)
	)
	blackboard.set_value(TARGET_POS_KEY, position)
	input_component.set_target_pos(position)
	return SUCCESS


func _get_configuration_warnings() -> PackedStringArray:
	var war: PackedStringArray = super._get_configuration_warnings()
	if not input_component:
		war.append("This action leaf requires an InputComponent")
	return war
