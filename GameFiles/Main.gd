extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var laser_trail = preload("res://Laser/Laser_anim.tscn")

func _ready():
	var players = get_tree().get_nodes_in_group("players")
	for player in players:
		player.	connect("hit", self, "hit_detection")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func hit_detection(collision_point, player_loc):
	var t = laser_trail.instance()
	add_child(t)
	t.position = player_loc
	var d = collision_point - player_loc
	print(d.length())
	t.set_region_rect(Rect2(0,0, d.length(), 2))