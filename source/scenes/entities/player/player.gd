@tool
class_name PlayerCharacterBody3D
extends CharacterBody3D

@export var stampable_sprite: ShadedAnimatedSprite3D:
	set(v):
		stampable_sprite = v
		notify_property_list_changed()
@export var movement_speed: float = 10.0
@export var death_on_y: float = -20.0
@export_group("Animations", "animation_")
@export var animation_death_start: StringName
@export var animation_death_loop: StringName
@export var animation_hit: StringName
@export var animation_fire: StringName
@export var animation_roll: StringName
@export var animation_attk: StringName
@export var animation_idle: StringName
@export var animation_walk: StringName
@export_group("States", "state_")
@export var state_idle: PlayerState
@export var state_walk: PlayerState
@export var state_dead: PlayerState
@export var state_roll: PlayerState
@export var state_hit: PlayerState
@export_subgroup("Attack", "state_attack_")
@export var state_attack_melee: PlayerState
@export var state_attack_ranged: PlayerState

var input_dir: Vector2 = Vector2.RIGHT
var _current_state: PlayerState


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	change_state(state_idle)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if _current_state:
		_current_state.handle_physics_process(delta)
	if not is_on_floor() and _current_state is not PlayerRollState:
		velocity += get_gravity() * delta
	move_and_slide()
	if not is_zero_approx(input_dir.x) and stampable_sprite:
		stampable_sprite.set_flip_h(input_dir.x < 0)


func _unhandled_input(event: InputEvent) -> void:
	if Engine.is_editor_hint():
		return
	if _current_state:
		_current_state.handle_input(event)


func _validate_property(property: Dictionary) -> void:
	if (property.name as String).begins_with("animation_"):
		var suggestions: PackedStringArray = (
			stampable_sprite.sprite_frames.get_animation_names()
			if stampable_sprite else PackedStringArray()
		)
		property.hint = PROPERTY_HINT_ENUM_SUGGESTION
		property.hint_string = ",".join(suggestions)


func change_state(new_state: PlayerState) -> void:
	var old_state: PlayerState = _current_state
	# if old_state == new_state and new_state is not PlayerMeleeAttackState:
	# 	return
	if _current_state:
		_current_state.exit_state()
	_current_state = new_state
	if not _current_state or _current_state is not PlayerState:
		printerr("No state found, reverting...")
		_current_state = old_state
		return
	_current_state.enter_state(self)


## Simplified shortcut for [method Input.get_vector] with preselected actions
func get_movement_vector() -> Vector2:
	return Input.get_vector(
		&"move_left",
		&"move_right",
		&"move_fowards",
		&"move_backwards",
	)


func _on_health_data_dead() -> void:
	change_state(state_dead)


func _on_health_data_success_hit(attack_info: AttackData) -> void:
	change_state(state_hit)
	stampable_sprite.stamp(attack_info.stamp_texture, attack_info.stamp_size)


func _on_health_data_success_heal(amount: float) -> void:
	stampable_sprite.clear_viewport()
	print("healed %d points" % amount)


func _on_animated_sprite_burned() -> void:
	pass # Do the return to last checkpoint thing
