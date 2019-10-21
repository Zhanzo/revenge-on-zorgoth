extends Area2D

signal level_complete

func _ready():
	$AnimationPlayer.play("default")

# warning-ignore:unused_argument
func _on_LevelEnd_body_entered(body):
	$PortalSound.play()
	$Timer.start()

func _on_Timer_timeout():
	emit_signal("level_complete")