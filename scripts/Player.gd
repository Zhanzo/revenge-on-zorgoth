extends KinematicBody2D

const SPEED = 120
const GRAVITY = 10
const JUMP_POWER = -250
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
var on_ground = true

func _ready():
	$AnimatedSprite.play("idle")

func _physics_process(delta):
	on_ground = is_on_floor()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		if on_ground:
			$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		if on_ground:
			$AnimatedSprite.play("run")
		$AnimatedSprite.flip_h = true
	else:
		velocity.x = 0
		if is_on_floor():
			$AnimatedSprite.play("idle")
	
	if Input.is_action_just_pressed("ui_up") and on_ground:
		velocity.y = JUMP_POWER
	
	if not on_ground:
		if velocity.y < 0:
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("fall")
			
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, FLOOR)
