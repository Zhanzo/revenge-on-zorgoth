extends Entity

const JUMP_POWER = -200

var is_attacking = false

var level = 1
var damage = 1
var max_health = 3
var required_experience = get_required_experience(level + 1)
var experience = 0


signal health_changed(health, max_health)
signal exp_changed(experience, required_experience)
signal died

func _ready():
	emit_signal("health_changed", health, max_health)
	emit_signal("exp_changed", experience, required_experience)
	
func _on_SwordHit_body_entered(body):
	var gained_exp = body.hit(damage)
	gain_exp(gained_exp)

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("died")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		is_attacking = false
	elif anim_name == "die":
		emit_signal("died")

func _physics_process(delta):
	var direction_x = get_x_direction()
	_velocity = calculate_move_velocity(direction_x, delta)
	
	var snap_vector = get_snap_vector()
	_velocity = move_and_slide_with_snap(_velocity, snap_vector, FLOOR_NORMAL, SNAP_THRESHOLD)
	
	_velocity.y = get_air_velocity()
	snap = get_snap_value()
	is_attacking = get_attack_state()
	
	update_animation()

func get_x_direction():
	return Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

func get_snap_vector():
	return Vector2(0, 32) if snap else Vector2()

func calculate_move_velocity(
		direction_x,
		delta
	):
	var out = _velocity
	out.x = speed * direction_x
	if Input.is_action_pressed("jump") and snap and not is_attacking:
		out.y = JUMP_POWER
		snap = false
	out.y += GRAVITY * delta
	return out

func get_air_velocity():
	if is_on_floor() and (Input.is_action_just_released("move_right") or Input.is_action_just_released("move_left")):
		return 0
	return _velocity.y

func get_snap_value():
	return is_on_floor() and not snap

func get_attack_state():
	if Input.is_action_pressed("attack") and not is_attacking and snap:
		return true
	return is_attacking

func flip(to_right):
	$Sprites.scale.x = 1 if to_right else -1

func update_animation():
	var animation = "idle"
	if abs(_velocity.x) > 10:
		animation = "run"
		flip(_velocity.x >= 0)
	
	if not is_on_floor():
		animation = "jump" if _velocity.y < 0 else "fall"
	
	if is_attacking:
		animation = "attack"
	
	if $AnimationPlayer.current_animation != animation:
		$AnimationPlayer.play(animation)

func hit(damage_to_player):
	if not is_attacking:
		health -= damage_to_player
		emit_signal("health_changed", health, max_health)
		if health <= 0:
			$AnimationPlayer.play("die")
			set_physics_process(false)
		else:
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