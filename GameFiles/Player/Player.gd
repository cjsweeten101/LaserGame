extends KinematicBody2D

export var max_speed = 600
export var accel = 200
export var gravity = 25
export var jump_height= -700
var current_speed = Vector2()
const UP = Vector2(0, -1)

export var direction = 1
onready var sprite = get_node("Sprite")

var can_shoot = true
onready var raycast = get_node("laser_cast")
export(Texture) var texture 

export var player_indx = 0
var input_dict = {}
var players_input_arr = [{'right': 'p1_move_right', 'left': 'p1_move_left', 'jump' : 'p1_jump' , 'shoot' : 'p1_shoot'},
						 {'right': 'p2_move_right', 'left': 'p2_move_left', 'jump' : 'p2_jump' , 'shoot' : 'p2_shoot'}]

signal hit

func _ready():
	sprite.texture = texture
	if player_indx == 0:
		input_dict = players_input_arr[0]
	elif player_indx == 1:
		input_dict = players_input_arr[1]

func _physics_process(delta):
	var friction = false
	
	current_speed.y += gravity
	if Input.is_action_pressed(input_dict["right"]):
		current_speed.x = min(current_speed.x + accel, max_speed)
		$Sprite.flip_h = false
		direction = 1
		raycast.rotation_degrees = 0
		if raycast.position.x < 0:
			raycast.position.x *= -1
	elif Input.is_action_pressed(input_dict['left']):
		current_speed.x = max(current_speed.x - accel, -max_speed)
		$Sprite.flip_h = true
		direction = -1
		raycast.rotation_degrees = 180
		if raycast.position.x > 0:
			raycast.position.x *= -1
	else:
		friction = true
	
	if is_on_floor():
		if Input.is_action_pressed(input_dict['jump']):
			current_speed.y = jump_height
		if friction == true:
			current_speed.x = lerp(current_speed.x, 0, .4)
	else:
		if friction == true:
			current_speed.x = lerp(current_speed.x, 0, .2)
	
	if Input.is_action_pressed(input_dict['shoot']) and can_shoot:
		can_shoot = false
		$reload.start()
		shoot()
	current_speed = move_and_slide(current_speed, UP)

func shoot():
	pass
	if raycast.is_colliding():
		emit_signal("hit", raycast, position, direction)
	
func _on_reload_timeout():
	can_shoot = true