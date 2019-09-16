extends KinematicBody2D

const SPEED = 120
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var on_ground = true
var is_attacking = false


func _ready():
	$AnimatedSprite.play("idle")


func _physics_process(delta):
	on_ground = is_on_floor()
	
	_handle_movement()
	_handle_jumping()
	_handle_attacking()
	
	_handle_sword_hitbox()
	_handle_air_animation()
			
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)


func _handle_movement():
	if Input.is_action_pressed("ui_right"):
		if not is_attacking:
			velocity.x = SPEED
			if on_ground:
				$AnimatedSprite.play("run")
			$AnimatedSprite.scale.x = 1
	elif Input.is_action_pressed("ui_left"):
		if not is_attacking:
			velocity.x = -SPEED
			if on_ground:
				$AnimatedSprite.play("run")
			$AnimatedSprite.scale.x = -1
	else:
		velocity.x = 0
		if on_ground and not is_attacking:
			$AnimatedSprite.play("idle")


func _handle_jumping():
	if Input.is_action_just_pressed("ui_up") and on_ground and not is_attacking:
		velocity.y = JUMP_POWER


func _handle_attacking():
	if Input.is_action_just_pressed("attack") and on_ground:
		velocity.x = 0
		is_attacking = true
		$AnimatedSprite.play("attack")


func _handle_sword_hitbox():
	if is_attacking: 
		if$AnimatedSprite.get_frame() == 2:
			$AnimatedSprite/SwordHit/CollisionShape2D.disabled = false
		elif $AnimatedSprite.get_frame() == 4:
			$AnimatedSprite/SwordHit/CollisionShape2D.disabled = true


func _handle_air_animation():
	if not on_ground:
		if velocity.y < 0:
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("fall")


func _on_AnimatedSprite_animation_finished():
	is_attacking = false


func _on_SwordHit_area_entered(area):
	pass # TODO: add damage to area if an enemy
