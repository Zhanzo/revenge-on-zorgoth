extends Control


signal health_changed(health, max_health)
signal exp_changed(experience, max_exp)

func _on_Player_health_changed(health, max_health):
	emit_signal("health_changed", health, max_health)


func _on_Player_exp_changed(experience, max_exp):
	emit_signal("exp_changed", experience, max_exp)
