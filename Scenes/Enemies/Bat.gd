extends KinematicBody2D

# Bat settings
export (int) var detect_radius = 100
export (int) var enemy_health = 10
export (int) var speed = 50

# Internal state
var player = null
var alive = true
var velocity = Vector2.ZERO

onready var anim = $AnimatedSprite

func _ready():
	# Set detection radius
	$DetectRadius/Radius.shape.radius = detect_radius
	
	# Connect signals
	$DetectRadius.connect("body_entered", self, "_on_body_entered")
	$DetectRadius.connect("body_exited", self, "_on_body_exited")
	# Always playing fly
	anim.play("Fly")

func _physics_process(delta):
	if not alive:
		return
	
	# Always play flying animation, even idle
	if not anim.is_playing() or anim.animation != "fly":
		anim.play("fly")
	
	if player != null and is_instance_valid(player):
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide(velocity)

		# Flip sprite based on horizontal direction
		if abs(velocity.x) > 0.1:
			anim.flip_h = velocity.x < 0
	else:
		velocity = Vector2.ZERO

func _on_DetectRadius_body_entered(body):
	if body.name == "Player":
		player = body

func _on_DetectRadius_body_exited(body):
	if body == player:
		player == null

func take_damage(amount):
	if not alive:
		return
	
	enemy_health -= amount
	
	if enemy_health <= 0:
		die()

func die():
	alive = false
	anim.play("Death")
	Global.add_score(1)
	yield(anim, "animation_finished")
	queue_free()
