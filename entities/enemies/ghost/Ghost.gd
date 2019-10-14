extends Entity

export var exp_worth = 5
export var damage_to_player = 2

var direction_x = -1

var is_visible = false
var is_attack_available = true
var is_attacking = false
var is_appearing = false
var is_vanishing = false
var is_dead = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "appear":
		is_appearing = false
		is_visible = true
	elif anim_name == "vanish":
		is_vanishing = false
		is_visible = false
	elif anim_name == "shriek":
		$AttackCD.start()
		$AttackAnimationPlayer.play("attack")
		is_attacking = false

func _on_HitAnimationPlayer_animation_finished(anim_name):
	if anim_name == "die":
		queue_free()

func _on_AttackCD_timeout():
	is_attack_available = true

func _on_ShriekArea_body_entered(body):
	body.hit(damage_to_player)

func _on_PlayerHitArea_body_entered(body):
	body.hit(damage_to_player)

func _physics_process(delta):
	direction_x = turn()
	_velocity = calculate_move_velocity(delta)
	var snap_vector = Vector2(0, 20)
	_velocity = move_and_slide_with_snap(_velocity, snap_vector, FLOOR_NORMAL, SNAP_THRESHOLD)
	
	choose_visibility()
	attack()
	update_animation()

func choose_visibility():
	if ($RayCasts/FrontRayCast.is_colliding() or $RayCasts/BackRayCast.is_colliding()) and not is_visible:
		is_appearing = true
	elif not ($RayCasts/FrontRayCast.is_colliding() or $RayCasts/BackRayCast.is_colliding()) and is_visible:
		is_vanishing = true

func update_animation():
	var animation = ""
	if is_appearing:
		animation = "appear"
	elif is_visible:
		animation = "idle"
		
		if is_attacking:
			animation = "shriek"
		elif is_vanishing:
			animation = "vanish"
	if $AnimationPlayer.current_animation != animation and animation != "":
		$AnimationPlayer.play(animation)

func attack():
	if is_attack_available and not is_attacking and is_visible:
		is_attack_available = false
		is_attacking = true

func calculate_move_velocity(delta):
	var out = _velocity
	out.y += GRAVITY * delta
	return out

func turn():
	if $RayCasts/BackRayCast.is_colliding():
		if direction_x == -1:
			$Sprites.scale.x = -1
			$CollisionShape2D.scale.x = -1
			$RayCasts.scale.x = -1
			return 1
		else:
			$Sprites.scale.x = 1
			$CollisionShape2D.scale.x = 1
			$RayCasts.scale.x = 1
			return -1

func hit(damage):
	if not is_dead and is_visible:
		health -= damage
		if health <= 0:
			$HitAnimationPlayer.play("die")
			set_collision_mask_bit(3, false)
			$AnimationPlayer.stop()
			set_physics_process(false)
			return exp_worth
		$HitAnimationPlayer.play("hit")
	return 0