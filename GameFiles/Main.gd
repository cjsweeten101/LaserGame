extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


signal reflect

var laser_trail = preload("res://Laser/Laser_anim.tscn")
var raycast = preload("res://RayCast2D.tscn")
var game_over = false
var reflecting_rays = []
var new_ray

func _ready():
	connect('reflect', self, 'reflection')
	var players = get_tree().get_nodes_in_group("players")
	for player in players:
		player.connect("hit", self, "hit_detection")
	var nice = load("res://player_mirror.tscn")
	var ok = nice.instance()
	#add_child(ok)

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
		var destination_cast = raycast.cast_to.bounce(raycast.get_collision_normal())
		emit_signal("reflect", raycast.get_collision_point(), destination_cast)
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

func reflection(starting_point, cast_to_vector):
	new_ray = raycast.instance()
	if cast_to_vector.y < 0:
		new_ray.position = starting_point + Vector2(0,-1)
		if cast_to_vector.x < 0:
			new_ray.position = new_ray.position + Vector2(-1,0)
		elif cast_to_vector.x > 0:
			new_ray.position = new_ray.position + Vector2(1,0)
	elif cast_to_vector.y > 0:
		new_ray.position = starting_point + Vector2(0,1)
		if cast_to_vector.x < 0:
			new_ray.position = new_ray.position + Vector2(-1,0)
		elif cast_to_vector.x > 0:
			new_ray.position = new_ray.position + Vector2(1,0)
	if cast_to_vector.x < 0 and cast_to_vector.y == 0:
		new_ray.position = starting_point + Vector2(-1,0)
	elif cast_to_vector.x > 0 and cast_to_vector.y == 0:
		new_ray.position = starting_point + Vector2(1,0)
	new_ray.cast_to = cast_to_vector
	add_child(new_ray)
	reflecting_rays.append(new_ray)
	
func _physics_process(delta):
	for ray in reflecting_rays:
		if weakref(ray).get_ref() != null:
			draw_trail(ray)
			check_collision(ray)
		else:
			reflecting_rays.erase(ray)

func check_collision(r):
	if r.is_colliding():
		if r.get_collider() == null:
			return
		if r.get_collider().is_in_group("mirrors"):
			var destination = r.cast_to.bounce(r.get_collision_normal())
			emit_signal("reflect", r.get_collision_point(), destination)
		if r.get_collider().is_in_group("players"):
			r.get_collider().queue_free()
			$retry.show()
			game_over = true

func draw_trail(r):
	if r.get_collision_point() == Vector2(0,0):
		return
	var t = laser_trail.instance()
	var d = r.position - r.get_collision_point()
	t.position = r.position
	t.region_rect = Rect2(0,0, d.length(),2)
	var normal_vect = Vector2(1,0)
	var angle_in_rads = normal_vect.angle_to(r.cast_to)
	var angle_in_deg = rad2deg(angle_in_rads)
	t.rotation_degrees = angle_in_deg
	t.z_index = -1
	add_child(t)
	
	