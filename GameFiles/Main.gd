extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var laser_trail = preload("res://Laser/Laser_anim.tscn")
var test_boi = preload("res://test_boi.tscn")

func _ready():
	var players = get_tree().get_nodes_in_group("players")
	for player in players:
		player.	connect("hit", self, "hit_detection")

func hit_detection(raycast, player_loc, direction):
	var boi = test_boi.instance()
	boi.position = player_loc
	add_child(boi)
	var t = laser_trail.instance()
	var d = player_loc - raycast.get_collision_point()
	t.position = player_loc
	t.set_region_rect(Rect2(0,0, d.length(), 2))
	add_child(t)