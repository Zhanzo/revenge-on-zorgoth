extends Control

var level1_path = "res://levels/level1/Level1.tscn"
var level2_path = "res://levels/level2/Level2.tscn"
#var level3_path = "res://levels/level3/Level3.tscn"
var title_screen_path = "res://menus/title/Title.tscn"

var level1_completed = false
var level2_completed = false

func _ready():
	GameSaver.load_game()
	$MarginContainer/VBoxContainer/Levels/Level1Button.grab_focus()
	if not level1_completed:
		$MarginContainer/VBoxContainer/Levels/Level2Button.visible = false
	if not level2_completed:
		$MarginContainer/VBoxContainer/Levels/Level3Button.visible = false
		
func _on_Level1Button_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene(level1_path)
	
func _on_Level2Button_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene(level2_path)

func _on_Level3Button_pressed():
	#get_tree().change_scene(level3_path)
	pass

func _on_BackButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene(title_screen_path)
	
func load_game(save):
	if save.data.has("levels_completed"):
		var data = save.data["levels_completed"]
		level1_completed = data["level1"]
		level2_completed = data["level2"]