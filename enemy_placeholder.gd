extends CharacterBody2D

var run_speed = 250
var currently_engaged_enemy = null
@onready var timer: Timer = $Timer
var ready_to_attack = false

@export var hp = 40
@export var xp_value = 100
@export var friendly = false
#todo dmg should be calculated based on strength and weapon
@export var base_dmg = 5

#these variables will be dynamic, depending on the equipped weapon 
var in_attack_distance = false
var attack_cooldown = 1

func _physics_process(_delta):
	velocity = Vector2.ZERO
	if currently_engaged_enemy && global_position.distance_to(currently_engaged_enemy.global_position) > 75:
		velocity = global_position.direction_to(currently_engaged_enemy.global_position) * run_speed
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

func take_hit(dmg: int):
	hp -= dmg
	print("Enemy takes hit! Life remaining: " + str(hp))
	if hp <= 0:
		die()

func die():
	$AnimationPlayer.play("Death")
	await $AnimationPlayer.animation_finished
	SignalBus.xp_granted.emit(xp_value)
	self.queue_free();

func _on_timeout():
	ready_to_attack = true

func _on_detect_radius_body_entered(body: Node2D) -> void:
	#todo use groups
	if (body.get_path().get_name(body.get_path().get_name_count() - 1) == "PC"):
		currently_engaged_enemy = body

func _on_detect_radius_body_exited(body: Node2D) -> void:
	if body == currently_engaged_enemy:
		currently_engaged_enemy = null

func _on_attack_radius_body_entered(body: Node2D) -> void:
	#todo use groups
	if (body.get_path().get_name(body.get_path().get_name_count() - 1) == "PC"):
		in_attack_distance = true

func _on_attack_radius_body_exited(body: Node2D) -> void:
	if body == currently_engaged_enemy:
		in_attack_distance = false

func _on_damage_radius_body_entered(body: Node2D) -> void:
	if(body == currently_engaged_enemy):
		body.take_hit(base_dmg)

func _on_be_attacked_button_pressed() -> void:
	print("_on_be_attacked_button_pressed")
	SignalBus.object_clicked.emit(self)
