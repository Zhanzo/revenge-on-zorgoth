extends Level

func _ready():
	next_level = "res://menus/title/TitleScreen.tscn"

func _on_HellHoundBoss_tree_exited():
	$Level/LevelEnd.visible = true
	$Level/LevelEnd/CollisionShape2D.disabled = false

func _on_LevelEnd_body_entered(body):
	$GameSaver.save_stats()
	get_tree().change_scene(next_level)

func _on_Player_died():
	get_tree().reload_current_scene()
	$GameSaver.load_stats()
