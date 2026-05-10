@tool
class_name HPLessThanCondition
extends ConditionLeaf

@export_range(0.0, 100.0, 0.1, "suffix:%") var health_percentage: float = 20.0

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if not actor or actor is not StampableCharacter: return FAILURE
	var actor_stats: StatsComponent = (actor as StampableCharacter).stats_component
	if not actor_stats: return FAILURE
	var actor_health_percentage: float = actor_stats.health / actor_stats.max_health * 100
	if actor_health_percentage < health_percentage: return SUCCESS
	return FAILURE
