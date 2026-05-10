@tool
class_name SetAllyTargetAction
extends ActionLeaf

const ALLIES_KEY = BeehaveConsts.ALLIES_KEY
const TARGET_POS_KEY = BeehaveConsts.TARGET_POS_KEY

@export var input_component: InputComponent:
	set(v): input_component = v; update_configuration_warnings()


func tick(_actor: Node, blackboard: Blackboard) -> int:
	var allies: Array[EnemyCharacter] = []
	allies.assign(blackboard.get_value(ALLIES_KEY, []))
	if allies.is_empty(): return FAILURE
	var pos: Vector3 = (allies.pick_random() as EnemyCharacter).global_position
	blackboard.set_value(TARGET_POS_KEY, pos)
	input_component.set_target_pos(pos)
	return SUCCESS


func _get_configuration_warnings() -> PackedStringArray:
	var war: PackedStringArray = super._get_configuration_warnings()
	if not input_component:
		war.append("This action leaf requires an InputComponent")
	return war
