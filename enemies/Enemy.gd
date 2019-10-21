extends KinematicBody2D
class_name Enemy

export var exp_worth = 5
export var health = 1
export var damage = 1

const FLOOR_NORMAL = Vector2.UP
const GRAVITY = 600

var direction_x = -1
var velocity = Vector2.ZERO

signal died

func _on_HitAnimationPlayer_animation_finished(anim_name):
	if anim_name == "die":
		queue_free()

func turn():
	if $BackRayCast.is_colliding():
		scale.x *= -1
		direction_x *= -1

func hit(damage):
	health -= damage
	if health <= 0:
		$AnimationPlayer.stop()
		$HitAnimationPlayer.play("die")
		$CollisionShape2D.set_deferred("disabled", true)
		$PlayerHit/CollisionShape2D.set_deferred("disabled", true)
		emit_signal("died")
		set_physics_process(false)
		return exp_worth
	$HitAnimationPlayer.play("hit")
	return 0

func calculate_move_velocity(
		delta
	):
	var out = velocity
	out.y += GRAVITY * delta
	return out

func check_for_player_collision():
	for body in $PlayerHit.get_overlapping_bodies():
		body.hit(damage)