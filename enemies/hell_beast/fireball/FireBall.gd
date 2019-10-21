extends KinematicBody2D

const SPEED = 100

var direction = -1
var velocity = Vector2.ZERO
var damage = 1

func _ready():
	$AnimationPlayer.play("default")
	$ImpactSound.play()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	var collision_info = move_and_collide(velocity)
	if collision_info:
		var collider = collision_info.get_collider()
		if collider.name == "Player":
			collider.hit(damage)
		queue_free()

func set_fireball_direction(dir):
	direction = dir
	scale.x *= direction
	
func set_damage(dmg):
	damage = dmg