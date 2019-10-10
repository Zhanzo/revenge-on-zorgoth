extends Level

func _ready():
	next_level = "res://levels/level2/Level2.tscn"

func _on_Player_died():
	if $Player.position.x > 1110:
		get_tree().change_scene(next_level)
	else:
		get_tree().reload_current_scene()
