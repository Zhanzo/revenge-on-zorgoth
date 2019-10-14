extends Node2D
class_name Level

var next_level = ""

func _on_Player_died():
	get_tree().reload_current_scene()

func _on_LevelEnd_body_entered(body):
	print("Changing level to " + next_level)
	get_tree().change_scene(next_level)