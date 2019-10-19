extends Level

var is_zorgoth_encountered = false
var player_died_by_zorgoth = false

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
		$Level/Zorgoth._velocity.x = 30
	else:
		get_tree().reload_current_scene()

func _on_Zorgoth_screen_exited():
	if is_zorgoth_encountered and player_died_by_zorgoth:
		$Level/Zorgoth.queue_free()
		$Level/Player.set_physics_process(true)
		$Level/LevelEnd.visible = true
		$Level/LevelEnd/CollisionShape2D.disabled = false

func _on_Zorgoth_screen_entered():
	is_zorgoth_encountered = true

func _on_LevelEnd_body_entered(body):
	$GameSaver.save_stats()
	get_tree().change_scene_to(next_level)