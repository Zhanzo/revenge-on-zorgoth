extends Node2D
class_name Level

var next_level = ""

func _ready():
	$GameSaver.load_stats()

func _on_Player_died():
	get_tree().reload_current_scene()
	$GameSaver.load_stats()

func _on_LevelEnd_body_entered(body):
	$GameSaver.save_stats()
	get_tree().change_scene(next_level)