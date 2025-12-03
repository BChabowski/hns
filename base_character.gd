extends CharacterBody2D

var in_attack_distance=false
var currently_engaged_enemy: Node2D
@onready var timer: Timer = $Timer
var ready_to_attack = false

@export var speed = 400
@export var hp = 100
@export var base_dmg = 5
@export var attack_cooldown = 1

func try_attacking():
	if(in_attack_distance):
		timer.wait_time = attack_cooldown
		initiate_attack()

func initiate_attack():
	if(ready_to_attack):
		attack()
	if(timer.is_stopped()):
		timer.start(attack_cooldown)

func attack():
	if(in_attack_distance):
		$AnimationPlayer.play("Attack")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("Idle")
	ready_to_attack = false

func take_hit(dmg: int):
	hp -= dmg
	print("Player takes hit! Life remaining: " + str(hp))


func _on_attack_radius_body_entered(body: Node2D) -> void:
	#todo use groups
	if (body.get_path().get_name(body.get_path().get_name_count() - 1) == "PC"):
		in_attack_distance = true

func _on_attack_radius_body_exited(body: Node2D) -> void:
	in_attack_distance = false

func _on_damage_radius_body_entered(body: Node2D) -> void:
	if(body == currently_engaged_enemy):
		body.take_hit(base_dmg)

func _on_timeout() -> void:
	ready_to_attack = true
