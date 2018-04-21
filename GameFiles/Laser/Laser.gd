extends Area2D

export var speed = Vector2(3000, 0)
func _ready():
	var players = get_tree().get_nodes_in_group("players")
	for player in players:
		player.connect("laser_direction", self, "_assign_laser_direction")

func _assign_laser_direction(direction):
	#print(direction)
	#print(speed)
	if direction == "right":
		speed.x *= 1
	elif direction == "left":
		if speed.x > 0:
			print("times by neg")
			speed.x *= -1
			#print(speed)

func _process(delta):
	print(speed)
	translate(speed*delta)

func _on_body_entered(body):
	self.queue_free()
