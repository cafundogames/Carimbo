@tool
extends Node3D

@export_range(0.4, 10.0, 0.1, "suffix:m") var shield_distance: float = 1.5:
	set = set_shield_distance

@onready var sprite_1: Sprite3D = $Sprite1
@onready var sprite_2: Sprite3D = $Sprite2
@onready var sprite_3: Sprite3D = $Sprite3
@onready var sprite_4: Sprite3D = $Sprite4
@onready var particles: GPUParticles3D = $GPUParticles3D


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	shatter(false)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	rotate_y(deg_to_rad(5.0) * delta)


func set_shield_distance(new: float) -> void:
	shield_distance = new
	await ready
	sprite_1.position.z = -shield_distance
	sprite_2.position.x = -shield_distance
	sprite_3.position.z = shield_distance
	sprite_4.position.x = shield_distance
	var p: ParticleProcessMaterial = particles.process_material
	p.emission_ring_radius = maxf(shield_distance, 0.4)
	p.emission_ring_inner_radius = maxf(shield_distance - 0.3, 0.1)


func on_hit(_amount: float, source: ShieldData) -> void:
	particles.set_emitting(true)
	if source and source.shield <= 0.0:
		shatter()


func on_healed(_amount: float, source: ShieldData) -> void:
	if source and source.shield > 0.0:
		activate()


func shatter(emit_particles: bool = true) -> void:
	var t: Tween = create_tween()
	if emit_particles:
		t.tween_property(particles, ^"emitting", true, 0.0).from(false)
	t.set_parallel()
	t.tween_property(sprite_1, ^"scale", Vector3.ZERO, 1.0)
	t.tween_property(sprite_2, ^"scale", Vector3.ZERO, 1.0)
	t.tween_property(sprite_3, ^"scale", Vector3.ZERO, 1.0)
	t.tween_property(sprite_4, ^"scale", Vector3.ZERO, 1.0)
	t.set_parallel(false)
	t.tween_callback(hide)


func activate() -> void:
	var t: Tween = create_tween()
	t.tween_callback(show)
	t.set_parallel()
	t.tween_property(sprite_1, ^"scale", Vector3.ONE, 1.0)
	t.tween_property(sprite_2, ^"scale", Vector3.ONE, 1.0)
	t.tween_property(sprite_3, ^"scale", Vector3.ONE, 1.0)
	t.tween_property(sprite_4, ^"scale", Vector3.ONE, 1.0)
	t.set_parallel(false)
