extends CharacterBody2D

@export var speed = 400
@export var hp = 100
@export var base_dmg = 5
@export var attack_cooldown = 1

var target = position
var moving = false
var in_attack_distance=false
var currently_engaged_enemy: Node2D
@onready var timer: Timer = $Timer
var ready_to_attack = false

func _ready() -> void:
	SignalBus.object_clicked.connect(react_to_object_clicked)

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
	try_attacking()

#copied from enemy class
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
###

func react_to_object_clicked(body: Node2D):
	target = body.global_position
	#attack
	currently_engaged_enemy = body
	for overlapping in $AttackRadius.get_overlapping_bodies():
		if(overlapping == currently_engaged_enemy):
			print("Player attack!")


func _on_attack_radius_body_entered(body: Node2D) -> void:
	#todo use groups
	if (body.get_path().get_name(body.get_path().get_name_count() - 1) == "EnemyPlaceholder"):
		if currently_engaged_enemy && currently_engaged_enemy == body:
			in_attack_distance = true

#copied from enemy class
func _on_attack_radius_body_exited(body: Node2D) -> void:
	in_attack_distance = false

func _on_damage_radius_body_entered(body: Node2D) -> void:
	if currently_engaged_enemy == body:
		body.take_hit(base_dmg)

func _on_timeout() -> void:
	ready_to_attack = true
###
