extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var laser_trail = preload("res://Laser/Laser_anim.tscn")

func _ready():
	var players = get_tree().get_nodes_in_group("players")
	for player in players:
		player.	connect("hit", self, "hit_detection")

func hit_detection(raycast, player_loc, direction):
	pass