extends Area2D

export var speed = Vector2(4000, 0)

func _ready():
	print("laser instanced")

func _process(delta):
	position += speed*delta

func _on_body_entered(body):
	#if body.is_in_group("walls"):
	self.queue_free()

func assign_direction(direction):
	print(direction)
	if direction == "right":
		speed.x *= 1
	elif direction == "left":
		speed.x *= -1