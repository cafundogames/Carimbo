@tool
class_name UntilInRangeDecorator
extends Decorator

const TARGET_KEY = BeehaveConsts.TARGET_POS_KEY

@export_range(0.5, 100.0, 0.1, "suffix:m", "or_greater") var view_range: float = 1.0

func tick(actor: Node, blackboard: Blackboard) -> int:
	var target: Vector3 = blackboard.get_value(TARGET_KEY)
	if not target or actor is not Node3D: return FAILURE
	var dist: float = (actor as Node3D).global_position.distance_to(target)

	var c: BeehaveNode = get_child(0)

	if c != running_child:
		c.before_run(actor, blackboard)

	var response: int = c._safe_tick(actor, blackboard)
	if can_send_message(blackboard):
		BeehaveDebuggerMessages.process_tick(c.get_instance_id(), response, blackboard.get_debug_data())

	if c is ConditionLeaf:
		blackboard.set_value("last_condition", c, str(actor.get_instance_id()))
		blackboard.set_value("last_condition_status", response, str(actor.get_instance_id()))

	if dist > view_range:
		if response == RUNNING:
			running_child = c
			if c is ActionLeaf:
				blackboard.set_value("running_action", c, str(actor.get_instance_id()))
		return RUNNING

	c.after_run(actor, blackboard)
	return SUCCESS
