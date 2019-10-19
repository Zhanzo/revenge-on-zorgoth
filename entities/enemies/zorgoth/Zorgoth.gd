extends Entity

export var damage_to_player = 5
export var exp_worth = 10
export(NodePath) var player_nodepath

var is_attacking = false
var is_attack_available = true
var player_node

signal screen_exited
signal screen_entered

func _ready():
	player_node = get_node(player_nodepath)

func _on_BreathArea_body_entered(body):
	body.hit(damage_to_player)
	
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "attack":
		is_attacking = false

func _on_HitAnimationPlayer_animation_finished(anim_name):
	if anim_name == "die":
		queue_free()

func _on_AttackCD_timeout():
	is_attack_available = true

func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("screen_exited")

func _on_VisibilityNotifier2D_screen_entered():
	emit_signal("screen_entered")

func _physics_process(delta):
	_velocity.y += GRAVITY * delta
	
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL, true)
	
	attack()
	update_animation()
	check_for_player_collision()

func attack():
	if $BreathRayCast.is_colliding() and is_attack_available:
		is_attack_available = false
		is_attacking = true
		$AnimationPlayer.play("attack")
		$AttackCD.start()

func update_animation():
	var animation = "idle"
	
	if is_attacking:
		animation = "attack"
	
	if $AnimationPlayer.current_animation != animation:
		$AnimationPlayer.play(animation)

func hit(damage):
	health -= damage
	if health <= 0:
		$HitAnimationPlayer.play("die")
		$AnimationPlayer.stop()
		$CollisionShape2D.disabled = true
		$PlayerHit/CollisionShape2D.disabled = true
		set_physics_process(false)
		return exp_worth
	$HitAnimationPlayer.play("hit")
	return 0

func check_for_player_collision():
	if $PlayerHit.overlaps_body(player_node):
    	player_node.hit(damage_to_player)