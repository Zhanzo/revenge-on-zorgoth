extends Entity

export var exp_worth = 1
export var damage_to_player = 1
var direction_x = -1
var is_dead = false

func _ready():
	set_physics_process(false)
	_velocity.x = -speed
	
func _on_PlayerHit_body_entered(body):
	body.hit(damage_to_player)

func _on_HitAnimationPlayer_animation_finished(anim_name):
	if anim_name == "die":
		queue_free()

func _physics_process(delta):
	direction_x *= turn()
	_velocity = calculate_move_velocity(delta)
	_velocity = move_and_slide_with_snap(_velocity, Vector2(0, 32), FLOOR_NORMAL, SNAP_THRESHOLD)
	update_animation()
	
func turn():
	return -1 if (is_on_wall() or not $GroundRayCast.is_colliding()) else 1

func calculate_move_velocity(
		delta
	):
	var out = _velocity
	out.x = speed * direction_x
	out.y += GRAVITY * delta
	return out
	
func hit(damage):
	if not is_dead:
		direction_x *= -1
		health -= damage
		if health <= 0:
			$HitAnimationPlayer.play("die")
			$AnimationPlayer.stop()
			set_collision_mask_bit(3, false)
			set_physics_process(false)
			return exp_worth
		$HitAnimationPlayer.play("hit")
	return 0
	
func flip(to_right):
	if to_right:
		$Sprites.scale.x = -1
		$CollisionShape2D.scale.x = -1
		$GroundRayCast.scale.x = -1
	else:
		$Sprites.scale.x = 1
		$CollisionShape2D.scale.x = 1
		$GroundRayCast.scale.x = 1

func update_animation():
	var animation = "idle"
	if abs(_velocity.x) > 10:
		animation = "walk"
		flip(_velocity.x >= 0)
	
	if $AnimationPlayer.current_animation != animation:
		$AnimationPlayer.play(animation, 0)