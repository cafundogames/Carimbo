@tool
class_name PlayAnimationAction
extends ActionLeaf

@export var animation_player: AnimationPlayer:
	set(v): animation_player = v; update_configuration_warnings(); notify_property_list_changed()
@export var animation_name: StringName:
	set(v): animation_name = v; update_configuration_warnings()


func tick(_actor: Node, _blackboard: Blackboard) -> int:
	if not animation_player: return FAILURE
	if not animation_name in animation_player.get_animation_list(): return FAILURE
	animation_player.play(animation_name)
	return SUCCESS


func _get_configuration_warnings() -> PackedStringArray:
	var war: PackedStringArray = super._get_configuration_warnings()
	if not animation_player:
		war.append("This action leaf requires an AnimationPlayer")
	if animation_name.is_empty():
		war.append("Select an animation name")
	return war


func _validate_property(property: Dictionary) -> void:
	if property.name == "animation_name" and animation_player:
		property.hint = PROPERTY_HINT_ENUM_SUGGESTION
		property.hint_string = ",".join(animation_player.get_animation_list())
