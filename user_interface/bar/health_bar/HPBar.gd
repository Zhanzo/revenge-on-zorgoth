extends MarginContainer

func _on_GUI_health_changed(health, max_health):
	$TextureProgress.value = health
	$TextureProgress.max_value = max_health
	$TextureProgress/Number.text = "%s / %s" % [health, max_health]
