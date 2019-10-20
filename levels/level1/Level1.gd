extends Node2D

var is_zorgoth_encountered = false
var player_died_by_zorgoth = false

var levels_completed = {
	"level1": true,
	"level2": false
}

var level_select_path = "res://menus/level_select/LevelSelect.tscn"

func _ready():
	GameSaver.load_game()

func _on_Timer_timeout():
	# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func _on_Player_died():
	if is_zorgoth_encountered:
		$Level/Player.health = $Level/Player.max_health
		$Level/Player.emit_signal(
						"health_changed", 
						$Level/Player.health, 
						$Level/Player.max_health
		)
		$Level/Zorgoth.scale.x *= -1
		is_zorgoth_encountered = true
		player_died_by_zorgoth = true
		$Level/Zorgoth.velocity.x = 30
	else:
		$GameOverSound.play()
		$Timer.start()

func _on_Zorgoth_screen_exited():
	if is_zorgoth_encountered and player_died_by_zorgoth:
		$Level/Zorgoth.queue_free()
		$Level/Player.set_physics_process(true)
		$Level/LevelEnd.visible = true
		$Level/LevelEnd/CollisionShape2D.set_deferred("disabled", false)
		$Level/LevelEnd/AnimationPlayer.play("default")

func _on_Zorgoth_screen_entered():
	is_zorgoth_encountered = true

func _on_LevelEnd_level_complete():
	GameSaver.save_game()
	# warning-ignore:return_value_discarded
	get_tree().change_scene(level_select_path)

func save_game(save):
	save.data["levels_completed"] = levels_completed

func load_game(save):
	if save.data.has("levels_completed"):
		levels_completed = save.data["levels_completed"]		