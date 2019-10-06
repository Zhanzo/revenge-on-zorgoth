extends Node2D
class_name Level

var next_level = ""

func _on_Player_died():
	get_tree().reload_current_scene()
