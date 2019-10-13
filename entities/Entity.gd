extends KinematicBody2D
class_name Entity

const FLOOR_NORMAL = Vector2.UP
const SNAP_THRESHOLD = 50
const GRAVITY = 600

export var speed = 60
export var health = 1
var snap = false
var _velocity = Vector2.ZERO