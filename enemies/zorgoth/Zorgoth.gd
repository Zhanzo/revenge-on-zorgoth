extends Enemy

var is_attacking = false
var attack_available = true

func _physics_process(delta):
	turn()
	attack()
	
	velocity.y += GRAVITY
	
	var snap_vector = Vector2(0, 32)
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, SNAP_THRESHOLD)
	
	update_animation()
	check_for_player_collision()

func update_animation():
	var animation = "idle"
	
	if is_attacking:
		animation = "attack"
	
	if $AnimationPlayer.current_animation != animation:
		$AnimationPlayer.play(animation)

func attack():
	if $FrontRayCast.is_colliding() and attack_available and not is_attacking:
		attack_available = false
		is_attacking = true
		$AnimationPlayer.play("attack")
		$AttackCD.start()

func _on_AttackCD_timeout():
	attack_available = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		is_attacking = false

func _on_BreathArea_body_entered(body):
	body.hurt(damage_to_player)
