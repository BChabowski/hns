extends CharacterBody2D

@export var speed = 400
@export var hp = 100
@export var base_dmg = 5
@export var attack_cooldown = 1

var current_xp_points = 0 #set from saved state on create
var xp_to_next_level = 1000 #set from saved state on create
var current_level = 0 #set from saved state on create

var target = position
var moving = false
var in_attack_distance=false
var currently_engaged_enemy: Node2D
@onready var timer: Timer = $Timer
var ready_to_attack = false

func _ready() -> void:
	SignalBus.object_clicked.connect(react_to_object_clicked)
	SignalBus.xp_granted.connect(add_xp_points)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			target = get_global_mouse_position()
			moving = true

func _physics_process(_delta):
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
	#reset attack shape so enemy can be attacked if it was in attack radius but not engaged
	$AttackRadius/AttackShape.disabled = true
	$AttackRadius/AttackShape.disabled = false
	currently_engaged_enemy = body

func add_xp_points(points):
	current_xp_points += points
	print("Player gains xp points! Current xp points amount: " + str(points))
	if current_xp_points > xp_to_next_level:
		raise_level()

func raise_level():
	pass #needs implementation

func _on_attack_radius_body_entered(body: Node2D) -> void:
	#todo maybe keep array of all nodes in this area?
	#todo use groups
	if (body.get_path().get_name(body.get_path().get_name_count() - 1) == "EnemyPlaceholder"):
		if currently_engaged_enemy && currently_engaged_enemy == body:
			in_attack_distance = true

#copied from enemy class
func _on_attack_radius_body_exited(body: Node2D) -> void:
	if body == currently_engaged_enemy:
		in_attack_distance = false

func _on_damage_radius_body_entered(body: Node2D) -> void:
	if currently_engaged_enemy == body:
		body.take_hit(base_dmg)

func _on_timeout() -> void:
	ready_to_attack = true
###
