extends KinematicBody2D

export var max_speed = 600
export var accel = 200
export var gravity = 25
export var jump_height= -700
var current_speed = Vector2()
const UP = Vector2(0, -1)

var hand_mirror = preload("res://player_mirror.tscn")
var mirror_deployed = false
var m
export var direction = 1
onready var sprite = get_node("Sprite")

var can_shoot = true
onready var raycast = get_node("laser_cast")
export(Texture) var texture 

export var player_indx = 0
var input_dict = {}
var players_input_arr = [{'right': 'p1_move_right', 'left': 'p1_move_left', 'jump' : 'p1_jump' , 'shoot' : 'p1_shoot', 'switch_item' : 'p1_switch_item'},
						 {'right': 'p2_move_right', 'left': 'p2_move_left', 'jump' : 'p2_jump' , 'shoot' : 'p2_shoot', 'switch_item' : 'p2_switch_item'}]

signal hit

func _ready():
	sprite.texture = texture
	if player_indx == 0:
		input_dict = players_input_arr[0]
	elif player_indx == 1:
		input_dict = players_input_arr[1]
	_hand_mirror_setup()

func _physics_process(delta):
	var friction = false
	
	current_speed.y += gravity
	if Input.is_action_pressed(input_dict["right"]):
		current_speed.x = min(current_speed.x + accel, max_speed)
		$Sprite.flip_h = false
		direction = 1
		if m.scale.x < 0:
			m.scale.x *= -1
			m.position.x *= -1
		if raycast.cast_to.x < 0:
			raycast.cast_to.x *= -1
		if raycast.position.x < 0:
			raycast.position.x *= -1
	elif Input.is_action_pressed(input_dict['left']):
		current_speed.x = max(current_speed.x - accel, -max_speed)
		$Sprite.flip_h = true
		direction = -1
		if m.scale.x > 0:
			m.scale.x *= -1
			m.position.x *= -1
		if raycast.cast_to.x > 0:
			raycast.cast_to.x *= -1
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
	
	if Input.is_action_pressed(input_dict['shoot']) and can_shoot and !mirror_deployed:
		can_shoot = false
		$reload.start()
		shoot()
	current_speed = move_and_slide(current_speed, UP)

func shoot():
	if raycast.is_colliding():
		emit_signal("hit", raycast, position, direction)
	
func _on_reload_timeout():
	can_shoot = true

func _hand_mirror_setup():
	m = hand_mirror.instance()
	add_child(m)
	m.visible = false
	m.collision_layer = false

func _input(event):
	if Input.is_action_pressed(input_dict['switch_item']):
		if !mirror_deployed:
			m.visible = true
			m.collision_layer = true
			mirror_deployed = true
		else:
			m.visible = false
			m.collision_layer = false
			mirror_deployed = false