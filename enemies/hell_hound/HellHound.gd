extends KinematicBody2D

const GRAVITY = 10
# negative to handle the hound facing left
const SPEED = -30
const FLOOR = Vector2(0, -1)
const SNAP_THRESHOLD = 50

var velocity = Vector2()
var health = 1


func hit(damage):
	health -= damage
	if health <= 0:
		queue_free()


func _physics_process(delta):
	var animation = "idle"
	velocity.x = 0
	if $PlayerRaycast.is_colliding():
		animation = "walk"
		velocity.x = SPEED
	
	$AnimatedSprite.play(animation)
	velocity.y += GRAVITY * delta
	
	var snap_vector = Vector2(0, 32)
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, SNAP_THRESHOLD)


func _on_PlayerHit_body_entered(body):
	print(body.name)
	if "Player" in body.name:
		body.hit()