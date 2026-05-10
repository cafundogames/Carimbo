@tool
class_name GetClosestNodePosition
extends ActionLeaf

@export var blackboard_key: StringName = "target"
@export_enum("player", "document") var node_group_name: String = "document"
@export var max_scan_range: float = INF


func tick(actor: Node, blackboard: Blackboard) -> int:
	var nodes: Array[Node3D]
	nodes.assign(get_tree().get_nodes_in_group(node_group_name).filter(func(n): return n is Node3D))
	var distance: float = max_scan_range
	var found: Node3D = null

	for node: Node3D in nodes:
		var dis: float = node.global_position.distance_to((actor as Node3D).global_position)
		if dis < distance:
			found = node
			distance = dis

	if not found:
		return FAILURE

	blackboard.set_value(blackboard_key, found)
	return SUCCESS
