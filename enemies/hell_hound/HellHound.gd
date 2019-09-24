extends KinematicBody2D

const GRAVITY = 10
const SPEED = 30
const FLOOR = Vector2(0, -1)
const SNAP_THRESHOLD = 50

var velocity = Vector2()
# negative to handle the hound facing left
var direction = -1


func dead():
	queue_free()


func _physics_process(delta):
	$AnimatedSprite.play("walk")
	
	velocity.x = SPEED * direction
	velocity.y += GRAVITY * delta
	
	var snap_vector = Vector2(0, 32)
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, SNAP_THRESHOLD)
	
	# change direction if we hit a wall or a ledge
	if is_on_wall() or not $RayCast2D.is_colliding():
		_change_direction()


func _change_direction():
	direction *= -1
	$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
	$RayCast2D.position.x *= -1