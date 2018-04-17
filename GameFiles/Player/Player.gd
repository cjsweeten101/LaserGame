extends KinematicBody2D

export var speed = 500

func _physics_process(delta):
	var direction = Vector2()
	if Input.is_action_pressed("move_right"):
		direction.x = 1
	if Input.is_action_pressed("move_left"):
		direction.x = -1
	var normalized_speed = direction.normalized() * speed * delta
	move_and_slide(normalized_speed)