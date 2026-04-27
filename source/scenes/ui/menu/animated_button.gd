@tool
class_name AnimatedButton
extends Button

signal burned

@export var label: String = "" :
	set(text):
		(%Label as Label).text = text
		label = text
@export var burn_on_press: bool = true

const burn_material: ShaderMaterial = preload("res://resources/shaders/button_burn_fx.tres")

@export var tween_duration: float = 0.1

@export_group("Scale")
@export var scale_ease_type: Tween.EaseType = Tween.EASE_IN_OUT
@export var scale_trans_type: Tween.TransitionType = Tween.TRANS_LINEAR
@export var scale_target: Vector2 = Vector2(1.1, 1.1)
var scale_tween: Tween

@export_group("Rotation")
@export var rot_ease_type: Tween.EaseType = Tween.EASE_IN_OUT
@export var rot_trans_type: Tween.TransitionType = Tween.TRANS_LINEAR
@export var rot_target: Vector2 = Vector2(1.1, 1.1)
@export_range(0.0, 180.0) var rot_range: float = 90.0
var rotate_tween: Tween

func _ready() -> void:
	pivot_offset_ratio = Vector2(0.5, 0.5)
	focus_entered.connect(_mouse_entered)
	focus_exited.connect(_mouse_exited)
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)
	pressed.connect(_pressed)

func _scale(target: Vector2) -> void:
	if scale_tween:
		scale_tween.kill()
	scale_tween = create_tween().set_ease(scale_ease_type).set_trans(scale_trans_type)
	scale_tween.tween_property(self, "scale", target, tween_duration)

func _rotate(target: float) -> void:
	if rotate_tween:
		rotate_tween.kill()
	rotate_tween = create_tween().set_ease(rot_ease_type).set_trans(rot_trans_type)
	rotate_tween.tween_property(self, "rotation", target, tween_duration)

func _reset() -> void:
	_scale(Vector2(1.0, 1.0))
	_rotate(0.0)

func _mouse_entered() -> void:
	if disabled: _reset(); return
	_scale(scale_target)
	_rotate(deg_to_rad(randf_range(-rot_range, rot_range)))

func _mouse_exited() -> void:
	if disabled: _reset(); return
	_reset()

func _pressed() -> void:
	if not burn_on_press: return

	material = burn_material.duplicate()
	_reset()
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"disabled", true, 0.01)
	tween.set_parallel(true)
	tween.tween_method(func(x: float):
		(material as ShaderMaterial).set_shader_parameter("burn_amount", x)
		, 0.0, 1.0, 1.0)
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 1.0)
	tween.finished.connect(burned.emit)
	tween.set_parallel(false)
	tween.tween_property(self, ^"disabled", false, 0.01)
