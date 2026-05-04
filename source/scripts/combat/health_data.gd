class_name HealthData
extends Node

signal success_hit(attack_info: AttackData)
signal success_heal(amount: float)
signal dead()

@export var debug_enable: bool = false

@export_range(0.1, 10.0, 0.1, "or_greater", "hide_control")
var initial_health: float = 1.0

@onready var health: float = self.initial_health


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"sub_rune") and debug_enable:
		health = minf(health + 2, self.initial_health)
		success_heal.emit(2)


func emit_success_hit(attack_info: AttackData) -> void:
	success_hit.emit(attack_info)


func on_success_hit(attack_info: AttackData) -> void:
	if health <= 0.0:
		return
	health = maxf(health - attack_info.attack_dmg, 0.0)
	emit_success_hit(attack_info)
	if health <= 0.0:
		dead.emit()
