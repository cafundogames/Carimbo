@tool
extends EditorPlugin
var _inspector_plugin

func _enter_tree():
	add_autoload_singleton("SceneManager", "res://addons/scene_manager/SceneManager.tscn")


func _exit_tree():
	remove_autoload_singleton("SceneManager")
