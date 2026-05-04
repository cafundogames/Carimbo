class_name HealthData
extends Node

signal success_hit(attack_info: AttackData)
signal damaged()
signal dead()

@export_range(0.0, 10.0, 0.1, "or_greater", "hide_control")
var initial_health: float = 1.0

@onready var health: float = self.initial_health


func emit_success_hit(attack_info: AttackData) -> void:
	success_hit.emit(attack_info)


func on_success_hit(attack_info: AttackData) -> void:
	if is_zero_approx(self.health):
		dead.emit()
		return
	var oldh: float = health
	health -= attack_info.attack_dmg
	if oldh != health:
		damaged.emit()
	emit_success_hit(attack_info)
