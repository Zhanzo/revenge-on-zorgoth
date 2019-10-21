extends Enemy

var is_attacking = false
var is_attack_available = true

signal screen_exited
signal screen_entered

func _ready():
	$AnimationPlayer.play("idle")

func _on_BreathArea_body_entered(body):
	body.hit(damage)
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		is_attacking = false
		$AnimationPlayer.play("idle")

func _on_AttackCD_timeout():
	is_attack_available = true

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("screen_exited")

func _on_VisibilityNotifier2D_screen_entered():
	emit_signal("screen_entered")

func _physics_process(delta):
	turn()
	velocity = calculate_move_velocity(delta)
	velocity = move_and_slide(velocity, FLOOR_NORMAL, true)
	attack()
	check_for_player_collision()

func attack():
	if $BreathRayCast.is_colliding() and is_attack_available:
		is_attack_available = false
		is_attacking = true
		$AnimationPlayer.play("attack")
		$AttackCD.start()