@tool
class_name SpawnAttack
extends ActionLeaf

@export var attack_scene: PackedScene


func tick(actor: Node, blackboard: Blackboard) -> int:
	assert(actor is EnemyCharacterBody3D, "[code]actor[/code] must extend EnemyCharacterBody3D")
	var body: EnemyCharacterBody3D = actor

	var attack: Node = attack_scene.instantiate()
	body.add_sibling(attack)
	if attack is Node3D:
		(attack as Node3D).look_at_from_position(
			body.global_position + body.last_direction * 2,
			body.global_position + body.last_direction * 3,
		)

	if can_send_message(blackboard):
		BeehaveDebuggerMessages.process_tick(self.get_instance_id(), SUCCESS, blackboard.get_debug_data())

	return SUCCESS
