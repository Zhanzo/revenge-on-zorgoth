extends Node2D
class_name Level

export (PackedScene) var next_level

func _ready():
	$GameSaver.load_stats()