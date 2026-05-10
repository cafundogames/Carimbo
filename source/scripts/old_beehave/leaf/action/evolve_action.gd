@tool
class_name EvolveAction
extends ActionLeaf

@export var evolution_entity_scene: PackedScene

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if not evolution_entity_scene: return FAILURE
	var new_entity: Node3D = evolution_entity_scene.instantiate()
	actor.add_sibling(new_entity)
	new_entity.set_global_position((actor as Node3D).global_position)
	if actor is EnemyCharacter: (actor as EnemyCharacter).death()
	else: actor.queue_free()
	return SUCCESS
