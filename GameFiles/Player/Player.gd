extends KinematicBody2D

export var max_speed = 600
export var accel = 200
export var gravity = 25
export var jump_height= -700
var direction = Vector2()
const UP = Vector2(0, -1)

var can_shoot = true
var laser = preload("res://Laser/Laser.tscn")

signal laser_direction

func _physics_process(delta):
	var friction = false
	
	direction.y += gravity
	if Input.is_action_pressed("move_right"):
		direction.x = min(direction.x + accel, max_speed)
		$Sprite.flip_h = false
	elif Input.is_action_pressed("move_left"):
		direction.x = max(direction.x - accel, -max_speed)
		$Sprite.flip_h = true
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
	
	if Input.is_action_pressed("shoot") and can_shoot:
		var main = get_parent()
		var new_laser = laser.instance()
		#Facing Left
		if $Sprite.flip_h:
			new_laser.position = position + Vector2(-64,0)
			emit_signal("laser_direction", "left")
			#print("emiititit")
		#Facing Right
		else:
			new_laser.position = position + Vector2(64,0)
			emit_signal("laser_direction", "right")
		main.add_child(new_laser)
		can_shoot = false
		$reload.start()
	direction = move_and_slide(direction, UP)

func _on_reload_timeout():
	can_shoot = true