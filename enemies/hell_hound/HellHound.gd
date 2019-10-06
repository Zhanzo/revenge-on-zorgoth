extends Enemy

func _physics_process(delta):
	velocity.x = move()
	turn()
	
	velocity.y += GRAVITY * delta
	
	var snap_vector = Vector2(0, 32)
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, SNAP_THRESHOLD)
	
	update_animation()
	check_for_player_collision()

func update_animation():
	var animation = "idle"
	if abs(velocity.x) > 0:
		animation = "walk"
	
	if $AnimationPlayer.current_animation != animation:
		$AnimationPlayer.play(animation, 0)