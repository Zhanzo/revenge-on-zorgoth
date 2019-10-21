extends Area2D

var damage = 1

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "default":
		queue_free()

func _on_Swoosh_body_entered(body):
	body.hit(damage)

func set_swoosh_direction(dir):
	scale.x *= dir
	
func set_damage(dmg):
	damage = dmg

func play_animation():
	$AnimationPlayer.play("default")