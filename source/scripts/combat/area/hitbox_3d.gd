@tool
class_name Hitbox3D
extends Area3D

@export var attack_info: AttackData


func _ready() -> void:
	monitorable = true
	monitoring = false
