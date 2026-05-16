@tool
class_name GetClosestNodeInGroup
extends ActionLeaf

@export var blackboard_key: StringName = "target_node"
@export_custom(3, "player,document") var node_group_name: String = "document"
@export_custom(0, "suffix:m") var max_scan_range: float = INF


func tick(actor: Node, blackboard: Blackboard) -> int:
	var actor_id: String = str(actor.get_instance_id())
	var nodes: Array[Node3D]
	nodes.assign(
		get_tree().get_nodes_in_group(node_group_name) \
		.filter(func(n): return n is Node3D) \
		.filter(func(n): return n != actor) \
		.filter(_filter_max_scan_range.bind(actor)),
	)
	var found: Node3D = nodes.reduce(_get_closest.bind(actor))
	if found == null:
		return FAILURE
	blackboard.set_value(blackboard_key, found, actor_id)
	return SUCCESS


func _get_closest(closest: Node3D, node: Node3D, actor: Node3D) -> Node3D:
	var cldis: float = closest.global_position.distance_to(actor.global_position)
	var nodis: float = node.global_position.distance_to(actor.global_position)
	return node if cldis > nodis else closest


func _filter_max_scan_range(n: Node3D, actor: Node3D) -> bool:
	return n.global_position.distance_to(actor.global_position) < max_scan_range
