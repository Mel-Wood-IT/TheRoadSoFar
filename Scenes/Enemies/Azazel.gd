extends KinematicBody2D

export (int) var speed = 50
export (int) var health = 1
export (int) var damage = 5
export (int) var attack_range = 24
export (int) var attack_buffer = 4

onready var anim = $AnimatedSprite
onready var cooldown = $AttackCooldown
onready var theme = $BossThemePlayer
onready var exorcism = $Exorcise

var player = null
var alive = true
var in_attack = false
var facing_left = false  # ✅ track facing direction

const FLIP_THRESHOLD = 5  # ✅ only flip when movement is clearly side to side
const ATTACK_COOLDOWN_TIME = 3.0

func _ready():
	print("Boss ready")
	$DetectRadius.connect("body_entered", self, "_on_DetectRadius_body_entered")
	$DetectRadius.connect("body_exited", self, "_on_DetectRadius_body_exited")
	cooldown.connect("timeout", self, "_on_AttackCooldown_timeout")
	anim.play("idle")
	exorcism.hide()
	theme.play()

func _physics_process(delta):
	if not alive or in_attack or player == null or not is_instance_valid(player):
		return

	var to_player = player.global_position - global_position
	var distance = to_player.length()

	# Flip direction only if player clearly crosses left/right boundary
	var dx = to_player.x
	if dx < -FLIP_THRESHOLD:
		if not facing_left:
			facing_left = true
			scale.x = -1
	elif dx > FLIP_THRESHOLD:
		if facing_left:
			facing_left = false
			scale.x = 1

	# Move toward player until within attack_range
	if distance > attack_range:
		var move_vec = to_player.normalized() * speed
		move_and_slide(move_vec)
		if anim.animation != "move":
			anim.play("move")
	else:
		# Stop moving when within attack_range
		move_and_slide(Vector2.ZERO)
		if anim.animation != "idle":
			anim.play("idle")

		# Attack if cooldown finished
		if not cooldown.is_stopped():
			# Still cooling down, do nothing
			pass
		elif not in_attack:
			start_attack()

func _on_AttackCooldown_timeout():
	if not alive or in_attack:
		return

	if player and is_instance_valid(player):
		var distance = global_position.distance_to(player.global_position)
		if distance <= attack_range + attack_buffer:
			start_attack()

func start_attack():
	print("Boss: starting spike_attack")
	in_attack = true
	anim.play("spike_attack")
	yield(anim, "animation_finished")

	if player and is_instance_valid(player):
		var dist = global_position.distance_to(player.global_position)
		if dist <= attack_range + attack_buffer and player.has_method("take_damage"):
			print("Boss: dealing", damage, "damage")
			player.take_damage(damage)

	in_attack = false
	anim.play("idle")
	cooldown.start()

func take_damage(amount):
	if not alive:
		return

	health -= amount
	print("Boss took damage:", amount, "| Remaining:", health)

	if health <= 0:
		die()

func die():
	print("Boss: dying now")
	alive = false
	anim.hide()
	theme.stop()
	cooldown.stop()

	exorcism.show()
	exorcism.play("exorcism")
	yield(exorcism, "animation_finished")

	queue_free()

func _on_DetectRadius_body_entered(body):
	if body.name == "Player":
		print("DetectRadius: Player entered")
		player = body

func _on_DetectRadius_body_exited(body):
	if body == player:
		print("DetectRadius: Player exited")
		player = null
