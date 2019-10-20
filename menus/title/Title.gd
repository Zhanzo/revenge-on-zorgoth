extends Control

var level_select_path = "res://menus/level_select/LevelSelect.tscn"

func _ready():
	if not GameSaver.save_exists():
		$VBoxContainer/HBoxContainer/Buttons/Continue.visible = false
		$VBoxContainer/HBoxContainer/Buttons/NewGame.grab_focus()
	else:
		$VBoxContainer/HBoxContainer/Buttons/Continue.grab_focus()

func _on_NewGame_pressed():
	GameSaver.delete_save()
# warning-ignore:return_value_discarded
	get_tree().change_scene(level_select_path)

func _on_Continue_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene(level_select_path)

func _on_ExitGame_pressed():
	get_tree().quit()