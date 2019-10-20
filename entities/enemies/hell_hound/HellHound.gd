extends Entity

export var exp_worth = 1
export (NodePath) var player_nodepath

var direction_x = -1
var player_node

func _ready():
	velocity.x = -speed
	player_node = get_node(player_nodepath)

func _on_HitAnimationPlayer_animation_finished(anim_name):
	if anim_name == "die":
		queue_free()

func _physics_process(delta):
	turn()
	velocity = calculate_move_velocity(delta)
	velocity = move_and_slide(velocity, FLOOR_NORMAL, true)
	update_animation()
	check_for_player_collision()
	
func turn():
	if is_on_wall() or not $RayCasts/GroundRayCast.is_colliding():
		if direction_x == -1:
			$Sprites.scale.x = -1
			$CollisionShape2D.scale.x = -1
			$RayCasts.scale.x = -1
			direction_x = 1
		else:
			$Sprites.scale.x = 1
			$CollisionShape2D.scale.x = 1
			$RayCasts.scale.x = 1
			direction_x = -1

func calculate_move_velocity(
		delta
	):
	var out = velocity
	out.x = speed * direction_x
	out.y += GRAVITY * delta
	return out
	
func hit(damage):
	$HitSound.play()
	health -= damage
	if health <= 0:
		$HitAnimationPlayer.play("die")
		$AnimationPlayer.stop()
		$CollisionShape2D.set_deferred("disabled", true)
		$PlayerHit/CollisionShape2D.set_deferred("disabled", true)
		set_physics_process(false)
		return exp_worth
	$HitAnimationPlayer.play("hit")
	return 0

func update_animation():
	var animation = "idle"
	if abs(velocity.x) > 10:
		animation = "walk"
	
	if $AnimationPlayer.current_animation != animation:
		$AnimationPlayer.play(animation, 0)

func check_for_player_collision():
	if $PlayerHit.overlaps_body(player_node):
    	player_node.hit(damage)