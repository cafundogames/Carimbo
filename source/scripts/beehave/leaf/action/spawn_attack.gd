@tool
class_name SpawnAttack
extends ActionLeaf

@export var attack_scene: PackedScene
@export var target_position_key: StringName = "target_position"
@export var at_target_position: bool = true:
	set(v):
		at_target_position = v
		notify_property_list_changed()
@export_custom(0, "suffix:m") var forward_offset: float = 3.0


func _validate_property(property: Dictionary) -> void:
	if property.name == "forward_offset":
		property.usage = PROPERTY_USAGE_NONE if at_target_position else property.usage


func tick(actor: Node, blackboard: Blackboard) -> int:
	var actor_id: String = str(actor.get_instance_id())
	var actor_position: Vector3 = (actor as Node3D).global_position
	var target_position: Vector3 = blackboard.get_value(target_position_key, actor_position, actor_id)
	var attack: Node3D = attack_scene.instantiate()
	actor.add_sibling(attack)
	if attack is not Node3D:
		return SUCCESS
	var dir_offset: Vector3 = actor_position.direction_to(target_position) * forward_offset
	actor_position += dir_offset

	attack.look_at_from_position(
		target_position if at_target_position else actor_position,
		actor_position if at_target_position else target_position,
	)
	return SUCCESS
