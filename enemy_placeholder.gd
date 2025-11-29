extends CharacterBody2D

var run_speed = 250
var player = null
@onready var timer: Timer = $Timer
var ready_to_attack = false
signal character_clicked(obj: Node2D)

@export var hp = 40
@export var friendly = false
#todo dmg should be calculated based on strength and weapon
@export var base_dmg = 5

#these variables will be dynamic, depending on the equipped weapon 
var in_attack_distance = false
var attack_cooldown = 1

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player && global_position.distance_to(player.global_position) > 75:
		velocity = global_position.direction_to(player.global_position) * run_speed
	move_and_slide()
	if(!friendly):
		try_attacking()

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

func _on_timeout():
	ready_to_attack = true

func _on_detect_radius_body_entered(body: Node2D) -> void:
	if (body.get_path().get_name(body.get_path().get_name_count() - 1) == "PC"):
		player = body

func _on_detect_radius_body_exited(body: Node2D) -> void:
	player = null

func _on_attack_radius_body_entered(body: Node2D) -> void:
	if (body.get_path().get_name(body.get_path().get_name_count() - 1) == "PC"):
		in_attack_distance = true

func _on_attack_radius_body_exited(body: Node2D) -> void:
	in_attack_distance = false

func _on_damage_radius_body_entered(body: Node2D) -> void:
	if(body == player):
		body.take_hit(base_dmg)

func _on_be_attacked_button_pressed() -> void:
	print("_on_be_attacked_button_pressed")
	#todo use signal bus
	character_clicked.emit(self)
