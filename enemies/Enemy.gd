extends KinematicBody2D

const GRAVITY = 10
const SPEED = 30
const SNAP_THRESHOLD = 50
const Player = preload("res://player/Player.gd")

var velocity = Vector2()
var direction = -1

export var health = 1
export var exp_worth = 1
export var damage_to_player = 1

signal give_exp(exp_worth)

func hit(damage):
	health -= damage
	if health <= 0:
		emit_signal("give_exp", exp_worth)
		queue_free()

func move():
	if $FrontRayCast.is_colliding() and $GroundRayCast.is_colliding():
		velocity.x = SPEED * direction

func turn():
	if $BackRayCast.is_colliding():
		direction *= -1
		scale.x *= -1

func check_for_player_collision():
	for i in range(get_slide_count()):
		var collider = get_slide_collision(i).collider
		if collider is Player:
			collider.hurt(damage_to_player)