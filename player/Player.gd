extends KinematicBody2D

const SPEED = 50
const GRAVITY = 600
const JUMP_POWER = -200
const SNAP_THRESHOLD = 50

var velocity = Vector2()

var snap = false
var is_attacking = false
var is_hurt = false

var level = 1
var damage = 1
var health = 3
var max_health = 3
var required_experience = get_required_experience(level + 1)
var experience = 0


signal health_changed(health, max_health)
signal exp_changed(experience, required_experience)


func _ready():
	emit_signal("health_changed", health, max_health)
	emit_signal("exp_changed", experience, required_experience)

func _physics_process(delta):
	velocity.x = 0
	var direction_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = direction_x * SPEED
	
	if Input.is_action_just_pressed("jump") and snap and not is_attacking:
		velocity.y = JUMP_POWER
		snap = false
	
	if Input.is_action_just_pressed("attack") and snap and not is_attacking and not is_hurt:
		is_attacking = true
	
	velocity.y += GRAVITY * delta
	
	var snap_vector = Vector2(0, 32) if snap else Vector2()
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, SNAP_THRESHOLD)
	
	if is_on_floor() and (Input.is_action_just_released("move_right") or Input.is_action_just_released("move_left")): 
		velocity.y = 0
	
	var just_landed = is_on_floor() and not snap
	if just_landed:
		snap = true
	
	update_animation()
	handle_sword_hitbox()

func update_animation():
	var animation = "idle"
	if abs(velocity.x) > 10:
		$AnimatedSprite.scale.x = -1 if velocity.x < 0 else 1
		animation = "run"
	
	if not is_on_floor():
		animation = "jump" if velocity.y < 0 else "fall"
	
	if is_attacking:
		animation = "attack"
	
	if is_hurt:
		animation = "hurt"
	
	if $AnimatedSprite.animation != animation:
		$AnimatedSprite.play(animation)


func hurt(damage_to_player):
	if not is_hurt and not is_attacking:
		is_hurt = true
		health -= damage_to_player
		if health <= 0:
			set_collision_layer_bit(0, false)
		$AnimatedSprite.play("hurt")
		emit_signal("health_changed", health, max_health)


func gain_exp(new_exp):
	experience += new_exp
	while experience >= required_experience:
		experience -= required_experience
		level_up()
	emit_signal("health_changed", health, max_health)
	emit_signal("exp_changed", experience, required_experience)
		

func get_required_experience(level):
	return round(pow(level, 1.8) + level * 1)

func level_up():
	level += 1
	max_health += 1
	health = max_health
	required_experience = get_required_experience(level + 1)

func handle_sword_hitbox():
	if is_attacking: 
		if$AnimatedSprite.get_frame() == 2:
			$AnimatedSprite/SwordHit/CollisionShape2D.disabled = false
		elif $AnimatedSprite.get_frame() == 4:
			$AnimatedSprite/SwordHit/CollisionShape2D.disabled = true

func _on_SwordHit_body_entered(body):
	body.hit(damage)

func _on_VisibilityNotifier2D_screen_exited():
	get_tree().reload_current_scene()

func _on_HellHound_give_exp(exp_worth):
	gain_exp(exp_worth)

func _on_AnimatedSprite_animation_finished():
	if is_attacking:
		is_attacking = false
	if is_hurt:
		is_hurt = false
		if health <= 0:
			get_tree().reload_current_scene()


func _on_Zorgoth_give_exp(exp_worth):
	gain_exp(exp_worth)
