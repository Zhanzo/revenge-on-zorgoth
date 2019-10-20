extends Entity

const JUMP_POWER = -200

var is_attacking = false
var is_jumping = false
var used_wall_jump = false
var is_hit = false

var level = 1
var max_health = 3
var required_experience = get_required_experience(level + 1)
var experience = 0

signal health_changed(health, max_health)
signal exp_changed(experience, required_experience)
signal died
	
func _on_SwordHit_body_entered(body):
	var gained_exp = body.hit(damage)
	gain_exp(gained_exp)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		is_attacking = false
	elif anim_name == "die":
		emit_signal("died")

func _on_HitAnimationPlayer_animation_finished(anim_name):
	if anim_name == "hit":
		is_hit = false

func _physics_process(delta):
	var direction_x = get_x_direction()
	velocity = calculate_move_velocity(direction_x, delta)
	
	velocity = move_and_slide(velocity, FLOOR_NORMAL, true)
	
	velocity.y = get_air_velocity()
	set_jump_value()
	is_attacking = get_attack_state()
	
	if position.y > 160:
		# falling in endless pit, kill the player
		emit_signal("died")
		set_physics_process(false)
	
	update_animation()

func get_x_direction():
	return Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

func calculate_move_velocity(
		direction_x,
		delta
	):
	var out = velocity
	out.x = speed * direction_x
	if Input.is_action_just_pressed("jump"):
		if not is_jumping:
			if is_attacking:
				is_attacking = false
			out.y = JUMP_POWER
			is_jumping = true
			$JumpSound.play()
		elif is_on_wall() and not used_wall_jump and not is_attacking:
			out.y = JUMP_POWER
			used_wall_jump = true
			$JumpSound.play()
	out.y += GRAVITY * delta
	return out

func get_air_velocity():
	if is_on_floor() and (Input.is_action_just_released("move_right") or Input.is_action_just_released("move_left")):
		return 0
	return velocity.y

func set_jump_value():
	if is_on_floor() and is_jumping:
		used_wall_jump = false
		is_jumping = false

func get_attack_state():
	if Input.is_action_just_pressed("attack") and not is_attacking and not is_jumping:
		$SwordSound.play()
		return true
	return is_attacking

func flip(to_right):
	$Sprites.scale.x = 1 if to_right else -1

func update_animation():
	var animation = "idle"
	if abs(velocity.x) > 5:
		animation = "run"
		flip(velocity.x >= 0)
	
	if not is_on_floor():
		animation = "jump" if velocity.y < 0 else "fall"
	
	if is_attacking:
		animation = "attack"
	
	if $AnimationPlayer.current_animation != animation:
		$AnimationPlayer.play(animation)

func hit(damage_to_player):
	if not is_hit:
		is_hit = true
		health -= damage_to_player
		emit_signal("health_changed", health, max_health)
		if health <= 0:
			$DeathSound.play()
			$AnimationPlayer.play("die")
			set_physics_process(false)
		else:
			$HitSound.play()
			$HitAnimationPlayer.play("hit")

func gain_exp(new_exp):
	var old_level = level
	experience += new_exp
	while experience >= required_experience:
		experience -= required_experience
		level_up()
	if old_level < level:
		emit_signal("health_changed", health, max_health)
		$LevelUp/AnimationPlayer.play("default")
	emit_signal("exp_changed", experience, required_experience)

func get_required_experience(level):
	return round(pow(level, 1.8) + level * 1)

func level_up():
	level += 1
	max_health += 1
	health = max_health
	required_experience = get_required_experience(level + 1)

func save_game(save):
	save.data["player"] = {
		"level": level,
		"damage": damage,
		"max_health": max_health,
		"health": health,
		"required_experience": required_experience,
		"experience": experience
	}

func load_game(save):
	var data = save.data["player"]
	level = data["level"]
	damage = data["damage"]
	max_health = data["max_health"]
	health = data["health"]
	required_experience = data["required_experience"]
	experience = data["experience"]
	emit_signal("health_changed", health, max_health)
	emit_signal("exp_changed", experience, required_experience)