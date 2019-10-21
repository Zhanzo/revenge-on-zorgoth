extends Enemy

export var speed = 30

func _ready():
	$AnimationPlayer.play("walk")

func _physics_process(delta):
	turn()
	velocity = calculate_move_velocity(delta)
	velocity = move_and_slide(velocity, FLOOR_NORMAL, true)
	check_for_player_collision()
	
func turn():
	if is_on_wall() or not $GroundRayCast.is_colliding():
		scale.x *= -1
		direction_x *= -1

func calculate_move_velocity(
		delta
	):
	var out = velocity
	out.x = speed * direction_x
	out.y += GRAVITY * delta
	return out