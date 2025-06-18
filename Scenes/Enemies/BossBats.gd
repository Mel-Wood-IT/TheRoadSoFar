extends KinematicBody2D

# -- Bat Settings --
export (int) var detect_radius = 100
export (int) var enemy_health = 10
export (int) var speed = 150


# -- Internal State --
var player = null
var alive = true
var velocity = Vector2.ZERO

# -- Nodes --
onready var anim = $AnimatedSprite
onready var detect_area = $DetectRadiusBossBat/RadiusBossBat
onready var attack_timer = $AttackCooldown

func _ready():
	detect_radius = 284  
	$DetectRadiusBossBat/RadiusBossBat.shape.radius = detect_radius
	print(name, "DetectRadius actual radius:", $DetectRadiusBossBat/RadiusBossBat.shape.radius)
	anim.play("Fly")
	
	$AttackCooldown.wait_time = 0.5  # Attack roughly 5x per second
	$AttackCooldown.one_shot = false
	
	

func _physics_process(delta):
	if not alive:
		return

	# Ensure animation stays consistent
	if not anim.is_playing() or anim.animation != "Fly":
		anim.play("Fly")

	if player != null and is_instance_valid(player):
		var distance = global_position.distance_to(player.global_position)

		if distance > 20:
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			move_and_slide(velocity)

			# Flip sprite based on movement
			if abs(velocity.x) > 0.1:
				anim.flip_h = velocity.x < 0
		else:
			velocity = Vector2.ZERO
			move_and_slide(velocity)

			if not attack_timer.is_stopped():
				return  # Already attacking

			attack_timer.start()

func _on_AttackCooldown_timeout():
	if alive and player != null and is_instance_valid(player):
		if global_position.distance_to(player.global_position) <= 20:
			if player.has_method("take_damage"):
				player.take_damage(10)
	attack_timer.start()

func _on_DetectRadiusBossBat_body_entered(body):
	if body.name == "Player":
		player = body
		var dist = global_position.distance_to(player.global_position)
		print("Player entered DetectRadius. Distance: ", dist)
		$AttackCooldown.start()

func _on_DetectRadiusBossBat_body_exited(body):
	if body == player:
		player = null  

func take_damage(amount):
	if not alive:
		print("Already dead")
		return

	enemy_health -= amount
	$BossBatDeath.stream.loop = false
	$BossBatDeath.play()
	if enemy_health <= 0:
		print("Bat died")
		die()

func die():
	alive = false
	anim.play("Death")
	$BossBatDeath.stream.loop = false
	$BossBatDeath.play()
	Global.add_score(5)
	yield(anim, "animation_finished")
	queue_free()
