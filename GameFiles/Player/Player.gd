extends KinematicBody2D

export var max_speed = 600
export var accel = 200
export var gravity = 25
export var jump_height= -700
var direction = Vector2()
const UP = Vector2(0, -1)

func _physics_process(delta):
	var friction = false
	
	direction.y += gravity
	if Input.is_action_pressed("move_right"):
		direction.x = min(direction.x + accel, max_speed)
	elif Input.is_action_pressed("move_left"):
		direction.x = max(direction.x - accel, -max_speed)
	else:
		friction = true
	
	if is_on_floor():
		if Input.is_action_pressed("move_up"):
			direction.y = jump_height
		if friction == true:
			direction.x = lerp(direction.x, 0, .4)
	else:
		if friction == true:
			direction.x = lerp(direction.x, 0, .2)
	direction = move_and_slide(direction, UP)