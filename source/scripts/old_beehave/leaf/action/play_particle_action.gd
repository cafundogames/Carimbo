@tool
class_name PlayParticleAction
extends ActionLeaf

@export var particle_scene: PackedScene

@onready var cache_key = "cache_%s" % self.get_instance_id()

func tick(actor: Node, blackboard: Blackboard) -> int:
	var particle: GPUParticles3D = blackboard.get_value(cache_key,
		_get_new_particle_instance(), str(get_instance_id()))
	actor.add_sibling(particle)
	particle.set_global_position((actor as Node3D).global_position)
	if particle.one_shot: particle.finished.connect(particle.queue_free)
	else:
		actor.tree_exiting.connect(particle.queue_free)
		blackboard.set_value(cache_key, particle, str(get_instance_id()))
	return SUCCESS


func _get_new_particle_instance() -> GPUParticles3D:
	var particle: GPUParticles3D = particle_scene.instantiate()
	particle.set_emitting(true)
	return particle
