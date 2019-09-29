extends MarginContainer

func _on_GUI_exp_changed(experience, max_exp):
	$TextureProgress.value = experience
	$TextureProgress.max_value = max_exp
	$TextureProgress/Number.text = "%s / %s" % [experience, max_exp]
