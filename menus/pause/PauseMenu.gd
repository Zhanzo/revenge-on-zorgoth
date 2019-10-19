extends Control

export (PackedScene) var title_screen

func _ready():
	$MarginContainer/CenterContainer/VBoxContainer/ContinueButton.grab_focus()

func _input(event):
	if event.is_action_pressed("pause"):
		$MarginContainer/CenterContainer/VBoxContainer/ContinueButton.grab_focus()
		get_tree().paused = not get_tree().paused
		visible = not visible

func _on_ContinueButton_pressed():
	get_tree().paused = not get_tree().paused
	visible = not visible

func _on_ExitButton_pressed():
	get_tree().paused = false
	get_tree().change_scene_to(title_screen)