@tool
class_name Hitbox3D
extends Area3D

@export var attack_info: AttackData
@export var is_projectile: bool = false:
	set(v):
		is_projectile = v
		notify_property_list_changed()
@export_range(0.1, 30.0, 0.1, "or_greater") var speed: float = 0.1
@export_custom(0, "suffix:s") var lifetime: float = 6.0

var velocity: Vector3


func _ready() -> void:
	monitorable = true
	monitoring = false
	get_tree().create_timer(lifetime).timeout.connect(self.queue_free)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint() or not is_projectile:
		return
	if velocity.is_zero_approx():
		velocity = _get_direction() * speed
	global_position = global_position + velocity * delta


func _get_direction() -> Vector3:
	var yaw: float = global_transform.basis.get_euler().y
	return Vector3.FORWARD.rotated(Vector3.UP, yaw).normalized()


func _validate_property(property: Dictionary) -> void:
	if property.name == "speed":
		property.usage = property.usage if is_projectile else PROPERTY_USAGE_NONE
