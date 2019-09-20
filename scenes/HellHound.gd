extends KinematicBody2D

const GRAVITY = 10
const SPEED = 30
const FLOOR = Vector2(0, -1)

var velocity = Vector2()
# negative to handle the hound facing left
var direction = -1

func _ready():
	pass 

func _physics_process(delta):
	$AnimatedSprite.play("walk")
	
	velocity.x = SPEED * direction
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, FLOOR)
	
	# change direction if we hit a wall or a ledge
	if is_on_wall() or not $RayCast2D.is_colliding():
		_change_direction()


func _change_direction():
	direction *= -1
	$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h
	$RayCast2D.position.x *= -1