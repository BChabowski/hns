extends CharacterBody2D

var ready_to_interact = false
var interaction_pending = false

func _physics_process(_delta: float) -> void:
	if ready_to_interact && interaction_pending:
		interact()
		interaction_pending = false

func interact():
	print("Hello there!")

func _on_interaction_radius_body_entered(body: Node2D) -> void:
	if (body.get_path().get_name(body.get_path().get_name_count() - 1) == "PC"):
		ready_to_interact = true

func _on_interaction_radius_body_exited(body: Node2D) -> void:
	if (body.get_path().get_name(body.get_path().get_name_count() - 1) == "PC"):
		ready_to_interact = false

func _on_interaction_button_pressed() -> void:
	interaction_pending = true
