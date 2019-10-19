extends Node2D
class_name Level

var next_level = ""

func _ready():
	$GameSaver.load_stats()