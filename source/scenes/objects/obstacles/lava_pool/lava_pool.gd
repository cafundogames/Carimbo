@tool
class_name LavaPool
extends Hitbox3D

@export var size: Vector2 = Vector2.ONE:
	set = set_size
@export var lava_mesh: MeshInstance3D
@export var hitbox_collision: CollisionShape3D


func _ready() -> void:
	monitorable = true
	monitoring = false


func _validate_property(property: Dictionary) -> void:
	if property.name == "lifetime":
		property.usage = PROPERTY_USAGE_NONE


func set_size(new: Vector2) -> void:
	size = new.max(Vector2.ONE)
	if not lava_mesh or not hitbox_collision:
		await ready
	(lava_mesh.mesh as PlaneMesh).size = size
	(hitbox_collision.shape as BoxShape3D).size = Vector3(
		size.x,
		1.0,
		size.y,
	)
	var material: ShaderMaterial = lava_mesh.mesh.surface_get_material(0)
	material.set_shader_parameter(&"uv_scale", size / 8.0)
