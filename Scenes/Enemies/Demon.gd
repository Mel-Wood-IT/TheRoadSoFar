extends KinematicBody2D

# Exported settings
export (int) var speed = 110
export (int) var health = 20
export (int) var attack_range = 24
export (int) var damage = 5
export (int) var attack_buffer = 4

# Internal state
var player = null
var alive = true
var anim_direction = "down"
var animation_locked = false
var attack_in_progress = false

onready var anim = $AnimatedSprite
onready var cooldown = $AttackCooldown

func _ready():
	anim.play("idle_down")
	$Exorcism.hide()
	set_physics_process(true)
	anim.connect("animation_finished", self, "_on_animation_finished")


func _physics_process(delta):
	if not alive or player == null or not is_instance_valid(player):
		return
	
	if animation_locked:
		return

	var to_player = player.global_position - global_position
	var distance = to_player.length()

	# Determine animation direction
	if abs(to_player.x) > abs(to_player.y):
		if to_player.x > 0:
			anim_direction = "right"
		else:
			anim_direction = "left"
	else:
		if to_player.y > 0:
			anim_direction = "down"
		else:
			anim_direction = "up"

	if distance <= attack_range + attack_buffer:
		move_and_slide(Vector2.ZERO)

		if attack_in_progress:
			# Do not change animation, attack animation is playing
			pass
		elif cooldown.is_stopped():
			# Ready to start new attack
			cooldown.start()
		else:
			# Waiting for cooldown
			anim.play("idle_" + anim_direction)
	else:
		# Chase player
		var move_vec = to_player.normalized() * speed
		move_and_slide(move_vec)
		anim.play("walk_" + anim_direction)

func _on_AttackCooldown_timeout():
	# Recheck player status and attack range
	if player and is_instance_valid(player) and alive:
		if global_position.distance_to(player.global_position) <= attack_range + attack_buffer:
			if not attack_in_progress:
				attack_in_progress = true
				animation_locked = true
				anim.play("attack_" + anim_direction)
				# cooldown will be restarted *after* animation
		else:
			# Restart cooldown so attack can retry later
			cooldown.start()

func _on_animation_finished():
	if anim.animation.begins_with("attack"):
		# Do damage after attack animation ends
		if player and is_instance_valid(player) and alive:
			if global_position.distance_to(player.global_position) <= attack_range + attack_buffer:
				if player.has_method("take_damage"):
					player.take_damage(damage)
		
		animation_locked = false
		attack_in_progress = false
		cooldown.start()  # Ensure attack loop continues

	elif anim.animation.begins_with("hurt"):
		animation_locked = false
		attack_in_progress = false  # ADD THIS LINE
		# Always restart cooldown after hurt ends
		cooldown.start()

func _on_DetectRadius_body_entered(body):
	if body.name == "Player":
		player = body

func _on_DetectRadius_body_exited(body):
	if body == player:
		player = null

func take_damage(amount):
	if not alive:
		return
	health -= amount

	if health <= 0:
		die()
	else:
		animation_locked = true
		anim.play("hurt_" + anim_direction)

func die():
	alive = false
	animation_locked = true
	anim.play("death_" + anim_direction)
	Global.add_score(2)
	yield(anim, "animation_finished")

	anim.hide()  
	$Exorcism.show()
	$Exorcism.play("exorcism")
	yield($Exorcism, "animation_finished")

	queue_free()
