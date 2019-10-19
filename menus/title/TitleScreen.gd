extends Control

func _ready():
	var directory = Directory.new()
	if not directory.file_exists("res://system/save/save.tres"):
		$VBoxContainer/HBoxContainer/Buttons/Continue.visible = false
		$VBoxContainer/HBoxContainer/Buttons/NewGame.grab_focus()
	else:
		$VBoxContainer/HBoxContainer/Buttons/Continue.grab_focus()

func _on_NewGame_pressed():
	var directory = Directory.new()
	if directory.file_exists("res://system/save/save.tres"):
		directory.remove("res://system/save/save.tres")
	get_tree().change_scene("res://levels/level1/Level1.tscn")

func _on_Continue_pressed():
	get_tree().change_scene("res://levels/level1/Level1.tscn")

func _on_ExitGame_pressed():
	get_tree().quit()