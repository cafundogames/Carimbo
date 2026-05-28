@tool
class_name PlayAnimation
extends ActionLeaf

@export var animation_sprite: AnimatedSprite3D:
	set(v):
		animation_sprite = v
		notify_property_list_changed()
@export var animation_name: StringName
@export var await_animation_finish: bool = true:
	set(v):
		await_animation_finish = v
		notify_property_list_changed()
@export_range(0, 10, 1, "or_greater") var max_loops: int = 1

var _last_animation: StringName
var _loops: int = 0
var _current_running: bool = false


func _ready() -> void:
	if animation_sprite and await_animation_finish:
		animation_sprite.animation_looped.connect(_on_animation_looped)
		animation_sprite.animation_finished.connect(func(): _loops = max_loops)


func _validate_property(property: Dictionary) -> void:
	var sprite_list: PackedStringArray = (
		animation_sprite.sprite_frames.get_animation_names() if animation_sprite
		else PackedStringArray()
	)
	if property.name == "animation_name":
		property.hint = PROPERTY_HINT_ENUM_SUGGESTION
		property.hint_string = ",".join(sprite_list)
	if property.name == "max_loops":
		property.usage = property.usage if await_animation_finish else PROPERTY_USAGE_NONE


func tick(_actor: Node, _blackboard: Blackboard) -> int:
	var response: int = RUNNING if await_animation_finish else SUCCESS
	if response == RUNNING and animation_sprite.get_animation() == animation_name:
		if animation_sprite.is_playing() and _loops < max_loops:
			_current_running = true
			response = RUNNING
		else:
			_current_running = false
			_loops = 0
			response = SUCCESS
	else:
		_last_animation = animation_sprite.get_animation()
		_current_running = await_animation_finish
		animation_sprite.play(animation_name)
	return response


func interrupt(_actor: Node, _blackboard: Blackboard) -> void:
	animation_sprite.play(_last_animation)
	_loops = 0
	_current_running = false


func _on_animation_looped() -> void:
	if _current_running:
		_loops += 1
