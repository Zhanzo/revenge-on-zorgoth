extends Enemy

const SWOOSH = preload("res:///enemies/ghost/swoosh/Swoosh.tscn")

var is_visible = false
var is_attack_available = true
var is_attacking = false
var is_appearing = false
var is_vanishing = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "appear":
		is_appearing = false
		is_visible = true
	elif anim_name == "vanish":
		is_vanishing = false
		is_visible = false
	elif anim_name == "attack":
		swoosh()
		$AttackCD.start()
		is_attacking = false

func _on_AttackCD_timeout():
	is_attack_available = true

# warning-ignore:unused_argument
func _physics_process(delta):
	turn()
	velocity = calculate_move_velocity(delta)
	velocity = move_and_slide(velocity, FLOOR_NORMAL, true)
	choose_visibility()
	attack()
	update_animation()
	check_for_player_collision()

func choose_visibility():
	if $FrontRayCast.is_colliding() and not is_visible:
		is_appearing = true
	elif not $FrontRayCast.is_colliding() and is_visible:
		is_vanishing = true

func update_animation():
	var animation = ""
	if is_appearing:
		animation = "appear"
	elif is_visible:
		animation = "idle"
		if is_attacking:
			animation = "attack"
		elif is_vanishing:
			animation = "vanish"
	if $AnimationPlayer.current_animation != animation and animation != "":
		$AnimationPlayer.play(animation)

func attack():
	if is_attack_available and not is_attacking and is_visible:
		is_attack_available = false
		is_attacking = true

func swoosh():
	var swoosh = SWOOSH.instance()
	swoosh.set_swoosh_direction(direction_x)
	swoosh.set_damage(damage)
	swoosh.position = $SwooshSpawn.global_position
	get_parent().add_child(swoosh)
	swoosh.play_animation()

func hit(damage):
	if is_visible:
		return .hit(damage)
	return 0