extends CharacterBody2D

@export var speed = 400
@export var hp = 100

var target = position
var moving = false
var in_attack_distance=false

func _ready() -> void:
	self.connect("character_clicked", attack)

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

func take_hit(dmg: int):
	hp -= dmg
	print("Player takes hit! Life remaining: " + str(hp))

func attack(body: Node2D):
	print("PC attack")
	for overlapping in $AttackRadius.get_overlapping_bodies():
		if(overlapping == body):
			print("Player attack!")
