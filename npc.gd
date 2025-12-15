extends CharacterBody2D

var ready_to_interact = false
var interaction_pending = false
@export var npc_id = 1


func _ready() -> void:
	add_to_group("NPC")

func _physics_process(_delta: float) -> void:
	if ready_to_interact && interaction_pending:
		interact()
		interaction_pending = false

func interact():
	SignalBus.show_dialog_box.emit(npc_id)

func _on_interaction_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("PC"):
		ready_to_interact = true

func _on_interaction_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("PC"):
		ready_to_interact = false

func _on_interaction_button_pressed() -> void:
	interaction_pending = true
	SignalBus.object_clicked.emit(self)
