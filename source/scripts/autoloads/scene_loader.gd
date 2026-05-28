class_name SceneLoaderAutoload
extends Node

signal progress_changed(progress: float)
signal scene_loaded()
signal scene_failed()

const LOADING_SCREEN: PackedScene = preload("uid://dossg3cl5gsqo")
const LEVEL_1 = "uid://dbx0mdbod3dh8"
const MAIN_MENU = "uid://dbdx47nsgglcq"

var loading_scene: LoadingScreen
var scene_path: String
var progress: Array = []
var use_sub_threads: bool = true
var _player: CharacterController3D
var _player_dest_pos: Vector3
var _last_paint_room: String


func _ready() -> void:
	set_process(false)
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	_last_paint_room = SaveSys.load_last_level()
	if not loading_scene:
		loading_scene = LOADING_SCREEN.instantiate()
		add_child(loading_scene)


func _process(_delta: float) -> void:
	if not scene_path:
		return
	var status: ResourceLoader.ThreadLoadStatus = \
	ResourceLoader.load_threaded_get_status(scene_path, progress)
	match status:
		ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			set_process(false)
			printerr("Scene Failed")
			scene_failed.emit()
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_changed.emit(progress.front())
		ResourceLoader.THREAD_LOAD_LOADED:
			_change_to_scene(ResourceLoader.load_threaded_get(scene_path))


func load_scene(_scene_path: String):
	await loading_scene.start_loading()
	start_load(_scene_path)


func load_scene_with_player(
		_scene_path: String,
		player: CharacterController3D,
		destination: Vector3 = Vector3.ZERO,
		paint_room: bool = false,
):
	_player_dest_pos = destination
	_player = player
	if paint_room:
		_last_paint_room = _scene_path
	load_scene(_scene_path)


func reset_player() -> void:
	if not is_instance_valid(_player) or not _player:
		return
	_player.queue_free()
	_player = null


func load_last_paint_room() -> void:
	_last_paint_room = SaveSys.load_last_level()
	if _last_paint_room.is_empty():
		_last_paint_room = LEVEL_1
	load_scene(_last_paint_room)


func load_main_menu() -> void:
	load_scene(MAIN_MENU)


func start_load(_scene_path: String):
	scene_path = _scene_path
	var state: Error = ResourceLoader.load_threaded_request(
		_scene_path,
		"PackedScene",
		use_sub_threads,
	)
	set_process(state == OK)


func _change_to_scene(scene: PackedScene) -> void:
	set_process(false)
	if _player:
		_player.reparent(self)
	get_tree().change_scene_to_packed(scene)
	await get_tree().scene_changed
	if _player:
		_player.reparent(get_tree().current_scene)
		_player.set_global_position.call_deferred(_player_dest_pos)
		_player = null
	_set_cameras()
	scene_loaded.emit()
	SaveSys.save_game_info(_last_paint_room)
	loading_scene.close()


func _set_cameras() -> void:
	for c: PhantomCamera3D in get_tree().get_nodes_in_group("camera"):
		c.set_follow_target(_player)
		c.append_follow_targets(_player)
