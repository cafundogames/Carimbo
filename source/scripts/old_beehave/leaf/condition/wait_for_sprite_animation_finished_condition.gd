@tool
class_name WaitForSpriteAnimationFinishedCondition
extends ConditionLeaf

@export var animated_sprite: AnimatedSprite3D:
	set(v): animated_sprite = v; update_configuration_warnings(); notify_property_list_changed()

func tick(_actor: Node, _blackboard: Blackboard) -> int:
	return RUNNING if animated_sprite.is_playing() else SUCCESS


func _get_configuration_warnings() -> PackedStringArray:
	var war: PackedStringArray = super._get_configuration_warnings()
	if not animated_sprite:
		war.append("This action leaf requires an AnimatedSprite3D")
	return war
