extends Level

func _ready():
	next_level = "res://title_screen/TitleScreen.tscn"

func _on_HellHoundBoss_tree_exited():
	$LevelEnd.visible = true
	$LevelEnd/Area2D/CollisionShape2D.disabled = false
