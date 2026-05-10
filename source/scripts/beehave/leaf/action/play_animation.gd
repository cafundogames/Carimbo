@tool
class_name PlayAnimation
extends ActionLeaf

@export var animation_sprite: AnimatedSprite3D
@export var animation_name: StringName


func _validate_property(property: Dictionary) -> void:
	var sprite_list: PackedStringArray = (
		animation_sprite.sprite_frames.get_animation_names() if animation_sprite
		else PackedStringArray()
	)
	var hint_string: String = ",".join(sprite_list)
	if property.name == "animation_name":
		property.hint = PROPERTY_HINT_ENUM_SUGGESTION
		property.hint_string = hint_string


func tick(_actor: Node, _blackboard: Blackboard) -> int:
	animation_sprite.play(animation_name)
	if animation_sprite.is_playing():
		return RUNNING
	return SUCCESS
