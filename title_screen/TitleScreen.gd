extends Control

func _ready():
	$VBoxContainer/HBoxContainer/Buttons/NewGame.grab_focus()
	
func _physics_process(delta):
	for button in $VBoxContainer/HBoxContainer/Buttons.get_children():
		if button.is_hovered():
			button.grab_focus()

func _on_NewGame_pressed():
	get_tree().change_scene("res://levels/level1/Level1.tscn")

func _on_Continue_pressed():
	pass
	#get_tree().change_scene("res://levels/level1/Level1.tscn")

func _on_ExitGame_pressed():
	get_tree().quit()