extends KinematicBody2D

# Bat settings
export (int) var detect_radius = 100
export (int) var enemy_health = 10
export (int) var speed = 80

# Internal state
var player = null
var alive = true
var velocity = Vector2.ZERO

onready var anim = $AnimatedSprite

func _ready():
	# Set detection radius
	$DetectRadius/Radius.shape.radius = detect_radius
	# Always playing fly
	anim.play("Fly")

func _physics_process(delta):
	if not alive:
		return

	# Always play flying animation
	if not anim.is_playing() or anim.animation != "Fly":
		anim.play("Fly")

	if player != null and is_instance_valid(player):
		var distance = global_position.distance_to(player.global_position)

		if distance > 20:
			# Chase the player
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide(velocity)

			if abs(velocity.x) > 0.1:
				anim.flip_h = velocity.x < 0
		else:
			# stop when close
			velocity = Vector2.ZERO
			move_and_slide(velocity)

func _on_AttackCooldown_timeout():
	if player != null and is_instance_valid(player) and alive:
		if global_position.distance_to(player.global_position) <= 20:
			if player.has_method("take_damage"):
				player.take_damage(1)
	$AttackCooldown.start()

func _on_DetectRadius_body_entered(body):
	if body.name == "Player":
		player = body
		$AttackCooldown.start()

func _on_DetectRadius_body_exited(body):
	if body == player:
		player == null

func take_damage(amount):
	if not alive:
		return
	
	enemy_health -= amount
	$BossBatDeath.stream.loop = false
	$BossBatDeath.play()
	if enemy_health <= 0:
		die()

func die():
	alive = false
	anim.play("Death")
	$BossBatDeath.stream.loop = false
	$BossBatDeath.play()
	Global.add_score(1)
	yield(anim, "animation_finished")
	queue_free()
