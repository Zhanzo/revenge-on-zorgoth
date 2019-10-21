extends Node2D

var level_select_path = "res://menus/level_select/LevelSelect.tscn"

var levels_completed = {
	"level1": true,
	"level2": true
}

func _ready():
	GameSaver.load_game()

func _on_Timer_timeout():
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	
func _on_Zorgoth_died():
	$Level/LevelEnd.visible = true
	$Level/LevelEnd/CollisionShape2D.set_deferred("disabled", false)

func _on_LevelEnd_level_complete():
	GameSaver.save_game()
	# warning-ignore:return_value_discarded
	get_tree().change_scene(level_select_path)

func _on_Player_died():
	$DeathSound.play()
	$Timer.start()

func save_game(save):
	save.data["levels_completed"] = levels_completed

# warning-ignore:unused_argument
func load_game(save):
	pass