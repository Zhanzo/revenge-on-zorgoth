extends Entity

export var damage_to_player = 5
export var exp_worth = 10

var is_attacking = false
var attack_available = true
var is_dead = false

func _on_BreathArea_body_entered(body):
	body.hit(damage_to_player)

func _on_PlayerHit_body_entered(body):
	body.hit(damage_to_player)
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		is_attacking = false

func _on_HitAnimationPlayer_animation_finished(anim_name):
	if anim_name == "die":
		queue_free()

func _on_BreathDetectionArea_body_entered(body):
	if attack_available:
		attack_available = false
		is_attacking = true
		$AnimationPlayer.play("attack")
		$AttackCD.start()

func _on_AttackCD_timeout():
	attack_available = true

func _physics_process(delta):
	_velocity.y += GRAVITY * delta
	
	var snap_vector = Vector2(0, 32)
	_velocity = move_and_slide_with_snap(_velocity, snap_vector, FLOOR_NORMAL, SNAP_THRESHOLD)
	
	update_animation()

func update_animation():
	var animation = "idle"
	
	if is_attacking:
		animation = "attack"
	
	if $AnimationPlayer.current_animation != animation:
		$AnimationPlayer.play(animation)

func hit(damage):
	if not is_dead:
		health -= damage
		if health <= 0:
			$HitAnimationPlayer.play("die")
			set_collision_mask_bit(3, false)
			set_physics_process(false)
			return exp_worth
		$HitAnimationPlayer.play("hit")
	return 0