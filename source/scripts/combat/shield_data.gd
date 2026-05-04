class_name ShieldData
extends Node

signal success_hit(attack_info: AttackData)

@export_range(0.0, 10.0, 0.1, "or_greater", "hide_control")
var initial_shield: float = 0.0

@onready var shield: float = self.initial_shield


func emit_success_hit(attack_info: AttackData) -> void:
	success_hit.emit(attack_info)


func _on_hurtbox_success_hit(attack_info: AttackData) -> void:
	if signf(attack_info.attack_dmg) < 0.0:
		emit_success_hit(attack_info)
		return
	shield = maxf(shield - attack_info.shield_dmg, 0.0)
	if is_zero_approx(self.shield):
		emit_success_hit(attack_info)
