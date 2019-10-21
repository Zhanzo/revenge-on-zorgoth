extends Enemy

const FIREBALL = preload("res://enemies/hell_beast/fireball/FireBall.tscn")

var is_attack_available = true
var is_attacking = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		shoot()
		$AttackCD.start()
		is_attacking = false

func _on_AttackCD_timeout():
	is_attack_available = true

# warning-ignore:unused_argument
func _physics_process(delta):
	turn()
	velocity = calculate_move_velocity(delta)
	velocity = move_and_slide(velocity, FLOOR_NORMAL, true)
	attack()
	update_animation()
	check_for_player_collision()

func update_animation():
	var animation = "idle"
	if is_attacking:
		animation = "attack"

	if $AnimationPlayer.current_animation != animation and animation != "":
		$AnimationPlayer.play(animation)

func attack():
	if is_attack_available and not is_attacking:
		is_attack_available = false
		is_attacking = true

func shoot():
	var fireball = FIREBALL.instance()
	fireball.set_fireball_direction(direction_x)
	fireball.set_damage(damage)
	fireball.position = $FireballSpawn.global_position
	get_parent().add_child(fireball)
	#$FireballSound.play()