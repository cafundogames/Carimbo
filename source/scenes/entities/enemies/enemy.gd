@tool
class_name EnemyCharacterBody3D
extends CharacterBody3D

@export var stampable_sprite: ShadedAnimatedSprite3D:
	set(v):
		stampable_sprite = v
		notify_property_list_changed()
@export var movement_speed: float = 10.0
@export var death_on_y: float = -20.0
@export_group("Animations", "animation_")
@export var animation_idle: StringName
@export var animation_walk: StringName
@export var animation_attk: StringName
@export var animation_hit: StringName
@export var animation_death: StringName
@export_group("States", "state_")
@export var state_beehave: EnemyState
@export var state_dead: EnemyState
@export var state_hit: EnemyState

var last_direction: Vector2 = Vector2.LEFT
var _current_state: EnemyState


func _ready() -> void:
	if not stampable_sprite:
		stampable_sprite = get_node_or_null(^"%ShadedAnimatedSprite3D")


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	if not is_zero_approx(last_direction.x) and stampable_sprite:
		stampable_sprite.set_flip_h(last_direction.x > 0)


func _validate_property(property: Dictionary) -> void:
	if (property.name as String).begins_with("animation_"):
		var suggestions: PackedStringArray = (
			stampable_sprite.sprite_frames.get_animation_names()
			if stampable_sprite else PackedStringArray()
		)
		property.hint = PROPERTY_HINT_ENUM_SUGGESTION
		property.hint_string = ",".join(suggestions)


func change_state(new_state: EnemyState) -> void:
	var old_state: EnemyState = _current_state
	if _current_state:
		_current_state.exit_state()
	_current_state = new_state
	if not _current_state or _current_state is not EnemyState:
		printerr("No state found, reverting...")
		change_state(old_state)
		return
	_current_state.enter_state(self)


func _on_navigation_agent_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity


func _on_health_data_dead() -> void:
	change_state(state_dead)


func _on_health_data_success_hit(attack_info: AttackData) -> void:
	change_state(state_hit)
	stampable_sprite.stamp(attack_info.stamp_texture, attack_info.stamp_size)


func _on_sprite_burned() -> void:
	# TODO: add maybe a signal (bus?) for levels to detect when an enemy died
	queue_free()
