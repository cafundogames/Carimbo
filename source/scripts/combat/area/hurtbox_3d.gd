@tool
class_name Hurtbox3D
extends Area3D

signal success_hit(attack_info: AttackData)

@export var actor: Node = self.owner

var active_modifiers: Array[Modifier]


func _ready() -> void:
	if not actor:
		actor = self.owner
	area_entered.connect(_on_area_entered)
	monitoring = true
	monitorable = false


func _process(delta: float) -> void:
	if active_modifiers.is_empty():
		return
	for mod: Modifier in active_modifiers:
		var finished = mod.process(delta)
		if finished:
			active_modifiers.erase.call_deferred(mod)


func emit_success_hit(attack_info: AttackData) -> void:
	success_hit.emit(attack_info)


func _on_area_entered(area: Area3D) -> void:
	if area is not Hitbox3D:
		return
	var box: Hitbox3D = area # casting for better lsp and linting
	for mod: Modifier in box.attack_info.mods:
		mod.apply(self)
	success_hit.emit(box.attack_info)
