class_name ShieldData
extends Node

signal success_hit(attack_info: AttackData)
signal hit(amount: float)
signal healed(amount: float)

@export_range(0.0, 10.0, 0.1, "or_greater", "hide_control")
var initial_shield: float = 0.0

@onready var shield: float = self.initial_shield



func emit_success_hit(attack_info: AttackData) -> void:
	success_hit.emit(attack_info)


func _on_hurtbox_success_hit(attack_info: AttackData) -> void:
	shield = maxf(shield - attack_info.shield_dmg, 0.0)
	hit.emit(attack_info.shield_dmg)
	if is_zero_approx(self.shield):
		emit_success_hit(attack_info)


func heal(amount: float = 1.0) -> void:
	shield += amount
	healed.emit(amount)
