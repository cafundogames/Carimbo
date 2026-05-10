@tool
class_name IsPlayingFramesAnimationCondition
extends ConditionLeaf

@export var animated_sprite: AnimatedSprite3D:
	set(v): animated_sprite = v; update_configuration_warnings(); notify_property_list_changed()
@export var animation_name: StringName:
	set(v): animation_name = v; update_configuration_warnings()


func tick(_actor: Node, _blackboard: Blackboard) -> int:
	if not animated_sprite: return FAILURE
	if not animation_name in animated_sprite.sprite_frames.get_animation_names(): return FAILURE
	if animated_sprite.animation == animation_name and animated_sprite.is_playing(): return SUCCESS
	return FAILURE


func _get_configuration_warnings() -> PackedStringArray:
	var war: PackedStringArray = super._get_configuration_warnings()
	if not animated_sprite:
		war.append("This action leaf requires an AnimatedSprite3D")
	if animation_name.is_empty():
		war.append("Select an animation name")
	return war


func _validate_property(property: Dictionary) -> void:
	if property.name == "animation_name" and animated_sprite:
		property.hint = PROPERTY_HINT_ENUM_SUGGESTION
		property.hint_string = ",".join(animated_sprite.sprite_frames.get_animation_names())
