extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var laser_trail = preload("res://Laser/Laser_anim.tscn")
var game_over = false

func _ready():
	var players = get_tree().get_nodes_in_group("players")
	for player in players:
		player.	connect("hit", self, "hit_detection")

func _input(event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	elif Input.is_key_pressed(KEY_ENTER) and game_over:
		get_tree().change_scene("res://Main.tscn")

func hit_detection(raycast, player_loc, direction):
	#player collision
	if raycast.get_collider().is_in_group("players"):
		raycast.get_collider().queue_free()
		$retry.show()
		game_over = true
	#Mirror collision
	elif raycast.get_collider().is_in_group("mirrors"):
		pass
	#trail
	var t = laser_trail.instance()
	var d = player_loc - raycast.get_collision_point()
	t.position = player_loc
	t.region_rect = Rect2(0,0,d.length(),2)
	t.z_index = -1
	if direction == 1:
		t.scale.x = 1
	elif direction == -1:
		t.scale.x = -1
	add_child(t)