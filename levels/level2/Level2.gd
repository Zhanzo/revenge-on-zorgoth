extends Node2D

var level_select_path = "res://menus/level_select/LevelSelect.tscn"

var levels_completed = {
	"level1": true,
	"level2": true
}

func _ready():
	GameSaver.load_game()

func _on_HellHoundBoss_tree_exited():
	$Level/LevelEnd.visible = true
	$Level/LevelEnd/CollisionShape2D.disabled = false

# warning-ignore:unused_argument
func _on_LevelEnd_body_entered(body):
	GameSaver.save_game()
# warning-ignore:return_value_discarded
	get_tree().change_scene(level_select_path)

func _on_Player_died():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	GameSaver.load_stats()

func save_game(save):
	save.data["levels_completed"] = levels_completed

func load_game(save):
	pass