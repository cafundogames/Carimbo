@tool
class_name EnemyBeehaveState
extends EnemyState

@export var beehave_tree: BeehaveTree


func _ready() -> void:
	if not beehave_tree:
		beehave_tree = get_node_or_null(^"%BeehaveTree")


func enter_state(actor: EnemyCharacterBody3D) -> void:
	super(actor)
	assert(beehave_tree != null, "MISSING BEEHAVE TREE")
	beehave_tree.enable()


func exit_state() -> void:
	assert(beehave_tree != null, "MISSING BEEHAVE TREE")
	beehave_tree.disable()


func handle_physics_process(_delta: float) -> void:
	if body.global_position.y <= body.death_on_y:
		body.change_state(body.state_dead)
