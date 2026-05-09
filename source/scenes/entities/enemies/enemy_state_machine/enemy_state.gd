@abstract
class_name EnemyState
extends Node

var body: EnemyCharacterBody3D


func enter_state(actor: EnemyCharacterBody3D) -> void:
	self.body = actor


func exit_state() -> void:
	pass


func handle_physics_process(_delta: float) -> void:
	pass
