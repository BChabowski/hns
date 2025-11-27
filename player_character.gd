extends CharacterBody2D

@export var speed = 400
@export var hp = 100

var target = position
var moving = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			target = get_global_mouse_position()
			moving = true

func _physics_process(delta):
	velocity = global_position.direction_to(target) * speed
	if moving:
		if global_position.distance_to(target) > 10:
			move_and_slide()
		else:
			moving = false
