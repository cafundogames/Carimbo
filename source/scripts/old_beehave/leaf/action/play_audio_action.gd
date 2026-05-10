@tool
class_name PlayAudioAction
extends ActionLeaf

@export var audio_player: AudioStreamPlayer3D:
	set(v): audio_player = v; update_configuration_warnings()


func tick(actor: Node, _blackboard: Blackboard) -> int:
	audio_player.play()
	return SUCCESS


func _get_configuration_warnings() -> PackedStringArray:
	var war: PackedStringArray = super._get_configuration_warnings()
	if not audio_player:
		war.append("This action leaf requires an AudioStreamPlayer3D")
	return war
