extends Level

var is_zorgoth_encountered = false

func _ready():
	next_level = "res://levels/level2/Level2.tscn"

func _on_Player_died():
	print("player died")
	if $Player.position.x > 1110 and not is_zorgoth_encountered:
		$Player.health = 1
		$Player.emit_signal("health_changed", $Player.health, $Player.max_health)
		$Zorgoth.scale.x *= -1
		is_zorgoth_encountered = true
		$Zorgoth._velocity.x = 30
	else:
		get_tree().reload_current_scene()

func _on_Zorgoth_screen_exited():
	if is_zorgoth_encountered:
		$Zorgoth.queue_free()
		$Player.set_physics_process(true)
