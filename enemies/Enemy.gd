extends KinematicBody2D

const GRAVITY = 10
# negative to handle the hound facing left
const SPEED = 30
const SNAP_THRESHOLD = 50
const Player = preload("res://player/Player.gd")

var velocity = Vector2()
var health = 1
var direction = -1
var exp_worth = 1

signal give_exp(exp_worth)

func hit(damage):
	health -= damage
	if health <= 0:
		emit_signal("give_exp", exp_worth)
		queue_free()

func _physics_process(delta):
	var animation = "idle"
	velocity.x = 0
	if $FrontRayCast.is_colliding() and $GroundRayCast.is_colliding():
		animation = "walk"
		velocity.x = SPEED * direction
	if $BackRayCast.is_colliding():
		direction *= -1
		scale.x *= -1
	
	$AnimatedSprite.play(animation)
	velocity.y += GRAVITY * delta
	
	var snap_vector = Vector2(0, 32)
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, SNAP_THRESHOLD)
	
	for i in range(get_slide_count()):
		var collider = get_slide_collision(i).collider
		if collider is Player:
			collider.hit()		