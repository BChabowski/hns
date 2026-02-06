extends CharacterBody2D

var ready_to_interact = false
var interaction_pending = false
@export var npc_id = 1
@export var system_prompt = "You are a poor blacksmith, a widower. 
You don't believe anything good will happen to you. There's a bandit camp nearby - you will gladly order someone to clean it for you. 
When asked for reward - and only then - promise one of your blacksmith hammers. Speak in short sentences. 
When interacted, respond only with blacksmith dialog lines."

func _ready() -> void:
	add_to_group("NPC")

func _physics_process(_delta: float) -> void:
	if ready_to_interact && interaction_pending:
		interact()
		interaction_pending = false

func interact():
	SignalBus.show_dialog_box.emit(self)

func _on_interaction_radius_body_entered(body: Node2D) -> void:
	if body.is_in_group("PC"):
		ready_to_interact = true

func _on_interaction_radius_body_exited(body: Node2D) -> void:
	if body.is_in_group("PC"):
		ready_to_interact = false

func _on_interaction_button_pressed() -> void:
	interaction_pending = true
	SignalBus.object_clicked.emit(self)

func _on_nobody_who_chat_response_finished(response: String) -> void:
	print(response)


func _on_nobody_who_chat_response_updated(new_token: String) -> void:
	print(new_token)
