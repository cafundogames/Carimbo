@tool
class_name QueueFreeAction
extends ActionLeaf

func tick(actor: Node, _blackboard: Blackboard) -> int:
	actor.queue_free()
	return SUCCESS
