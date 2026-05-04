class_name HealthData
extends Node

signal success_hit(attack_info: AttackData)
signal dead()

@export_range(0.1, 10.0, 0.1, "or_greater", "hide_control")
var initial_health: float = 1.0

@onready var health: float = self.initial_health


func emit_success_hit(attack_info: AttackData) -> void:
	success_hit.emit(attack_info)


func on_success_hit(attack_info: AttackData) -> void:
	health = maxf(health - attack_info.attack_dmg, 0.0)
	if self.health <= 0.0:
		dead.emit()
		return
	emit_success_hit(attack_info)
