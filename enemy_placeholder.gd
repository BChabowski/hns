extends CharacterBody2D

var run_speed = 250
var player = null

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player && global_position.distance_to(player.global_position) > 75:
		velocity = global_position.direction_to(player.global_position) * run_speed
	move_and_slide()

func _on_detect_radius_body_entered(body: Node2D) -> void:
	print("body")
	player = body

func _on_detect_radius_body_exited(body: Node2D) -> void:
	player = null
