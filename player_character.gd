extends CharacterBody2D

@export var speed = 400

var target = position
var moving = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Left button was clicked at ", event.position)
			target = get_global_mouse_position()
			moving = true
	# Use is_action_pressed to only accept single taps as input instead of mouse drags.
	#if event.is_action_pressed(&"click"):
		#print("Click")
		#target = get_global_mouse_position()

func _physics_process(delta):
	velocity = global_position.direction_to(target) * speed
	# look_at(target)
	if moving:
		if global_position.distance_to(target) > 10:
			move_and_slide()
		else:
			moving = false
