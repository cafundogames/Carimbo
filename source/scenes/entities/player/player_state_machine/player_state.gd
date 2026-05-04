@abstract
class_name PlayerState
extends Node

var player: PlayerCharacterBody3D


func enter_state(player_node: PlayerCharacterBody3D) -> void:
	self.player = player_node


func exit_state() -> void:
	pass


func handle_input(_event: InputEvent) -> void:
	pass


func handle_physics_process(_delta: float) -> void:
	pass
