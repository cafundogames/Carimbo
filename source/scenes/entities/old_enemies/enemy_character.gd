@tool
class_name EnemyCharacter
extends StampableCharacter

signal dead()
signal on_launch(block: bool)

@export var beehave_tree: BeehaveTree
@export var stats_component: StatsComponent

func _ready() -> void:
	if not stats_component: stats_component = get_children().filter(
		func(c: Node) -> bool: return c is StatsComponent).front()
	if not beehave_tree: beehave_tree = get_children().filter(
		func(c: Node) -> bool: return c is BeehaveTree).front()


func death() -> void:
	beehave_tree.disable()
	dead.emit()
	super.death()
	remove_from_group(BeehaveConsts.MONSTER_NODE_GROUP)


func block_move_component() -> void: on_launch.emit(true)
func unblock_move_component() -> void: on_launch.emit(false)


func on_being_hit() -> void:
	beehave_tree.disable()
	stampable_sprite.play(&"hit")
	if stampable_sprite.sprite_frames.get_animation_loop(&"hit"): await stampable_sprite.animation_looped
	else: await stampable_sprite.animation_finished
	if stats_component.health <= 0: return
	beehave_tree.enable()
