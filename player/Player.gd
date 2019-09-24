extends KinematicBody2D

const SPEED = 100
const GRAVITY = 1200
const JUMP_POWER = -400
const FLOOR = Vector2(0, -2)
const SNAP_THRESHOLD = 50

var velocity = Vector2()
var snap = false
var is_attacking = false


func _ready():
	$AnimatedSprite.play("idle")


func _physics_process(delta):
	velocity.x = 0
	if not is_attacking:
		var direction_x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		velocity.x = direction_x * SPEED
	
	if Input.is_action_just_pressed("jump") and snap and not is_attacking:
		velocity.y = JUMP_POWER
		snap = false
	
	if Input.is_action_just_pressed("attack") and snap:
		is_attacking = true
	
	velocity.y += GRAVITY * delta
	
	var snap_vector = Vector2(0, 32) if snap else Vector2()
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, SNAP_THRESHOLD)
	
	if is_on_floor() and (Input.is_action_just_released("move_right") or Input.is_action_just_released("move_left")): 
		velocity.y = 0
	
	var just_landed = is_on_floor() and not snap
	if just_landed:
		snap = true
	
	update_animation(velocity)
	_handle_sword_hitbox()
	

func update_animation(velocity):
	var animation = "idle"
	if abs(velocity.x) > 10:
		$AnimatedSprite.flip_h = velocity.x < 0
		animation = "run"
	
	if not is_on_floor():
		animation = "jump" if velocity.y < 0 else "fall"
	
	if is_attacking:
		animation = "attack"
	
	if $AnimatedSprite.animation != animation:
		$AnimatedSprite.play(animation)


func _handle_sword_hitbox():
	if is_attacking: 
		if$AnimatedSprite.get_frame() == 2:
			$AnimatedSprite/SwordHit/CollisionShape2D.disabled = false
		elif $AnimatedSprite.get_frame() == 4:
			$AnimatedSprite/SwordHit/CollisionShape2D.disabled = true


func _on_AnimatedSprite_animation_finished():
	is_attacking = false


func _on_SwordHit_body_entered(body):
	if "HellHound" in body.name:
		body.dead()
