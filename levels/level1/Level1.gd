extends Level

var is_zorgoth_encountered = false
var player_died_by_zorgoth = false

func _ready():
	next_level = "res://levels/level2/Level2.tscn"

func _on_Player_died():
	if is_zorgoth_encountered:
		print("defeated")
		$Player.health = $Player.max_health
		$Player.emit_signal("health_changed", $Player.health, $Player.max_health)
		$Zorgoth.scale.x *= -1
		is_zorgoth_encountered = true
		player_died_by_zorgoth = true
		$Zorgoth._velocity.x = 30
	else:
		get_tree().reload_current_scene()

func _on_Zorgoth_screen_exited():
	if is_zorgoth_encountered and player_died_by_zorgoth:
		$Zorgoth.queue_free()
		$Player.set_physics_process(true)

func _on_Zorgoth_screen_entered():
	is_zorgoth_encountered = true


