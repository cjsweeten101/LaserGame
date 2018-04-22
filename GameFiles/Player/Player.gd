extends KinematicBody2D

export var max_speed = 600
export var accel = 200
export var gravity = 25
export var jump_height= -700
var direction = Vector2()
const UP = Vector2(0, -1)

var can_shoot = true
var laser = preload("res://Laser/Laser.tscn")
onready var raycast = get_node("laser_cast")

signal hit

func _physics_process(delta):
	var friction = false
	
	direction.y += gravity
	if Input.is_action_pressed("move_right"):
		direction.x = min(direction.x + accel, max_speed)
		$Sprite.flip_h = false
		raycast.rotation_degrees = 0
	elif Input.is_action_pressed("move_left"):
		direction.x = max(direction.x - accel, -max_speed)
		$Sprite.flip_h = true
		raycast.rotation_degrees = 180
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
		shoot()
		can_shoot = false
		$reload.start()
	direction = move_and_slide(direction, UP)

func shoot():
	if raycast.is_colliding():
		emit_signal("hit", raycast.get_collision_point(), position)
	
func _on_reload_timeout():
	can_shoot = true