extends KinematicBody2D

export var max_speed = 600
export var accel = 200
export var gravity = 10
var direction = Vector2()
const UP = Vector2(0, -1)

func _physics_process(delta):
	direction.y += gravity
	if Input.is_action_pressed("move_right"):
		direction.x = min(direction.x + accel, max_speed)
	elif Input.is_action_pressed("move_left"):
		direction.x = max(direction.x - accel, -max_speed)
	else:
		direction.x = 0
	direction = move_and_slide(direction)