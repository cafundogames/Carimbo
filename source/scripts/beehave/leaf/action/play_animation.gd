@tool
class_name PlayAnimation
extends ActionLeaf

@export var animation_sprite: AnimatedSprite3D
@export var animation_name: StringName
@export var await_animation_finish: bool = true

var _last_animation: StringName

func _validate_property(property: Dictionary) -> void:
	var sprite_list: PackedStringArray = (
		animation_sprite.sprite_frames.get_animation_names() if animation_sprite
		else PackedStringArray()
	)
	if property.name == "animation_name":
		property.hint = PROPERTY_HINT_ENUM_SUGGESTION
		property.hint_string = ",".join(sprite_list)


func tick(_actor: Node, _blackboard: Blackboard) -> int:
	if animation_sprite.get_animation() == animation_name:
		if animation_sprite.is_playing() and await_animation_finish:
			return RUNNING
		return SUCCESS
	_last_animation = animation_sprite.get_animation()
	animation_sprite.play(animation_name)
	return RUNNING


func interrupt(_actor: Node, _blackboard: Blackboard) -> void:
	animation_sprite.play(_last_animation)
