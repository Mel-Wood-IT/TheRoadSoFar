extends Area2D

export var speed = 700
var direction = "right"
var velocity = Vector2.ZERO

onready var anim = $BulletAnim

func _ready():
	set_direction(direction)

	$Timer.wait_time = 0.5
	$Timer.start()

	if not $Timer.is_connected("timeout", self, "_on_Timer_timeout"):
		$Timer.connect("timeout", self, "_on_Timer_timeout")
		print("Connected timer timeout to bullet")

	print("Bullet READY at position:", global_position)
	print("Bullet animation playing:", anim.animation)


func set_direction(value):
	direction = value

	match direction:
		"up":
			velocity = Vector2(0, -1)
			anim.play("bullet_up")
		"down":
			velocity = Vector2(0, 1)
			anim.play("bullet_down")
		"left":
			velocity = Vector2(-1, 0)
			anim.play("bullet_left")
		"right":
			velocity = Vector2(1, 0)
			anim.play("bullet_right")

	print("Bullet direction set to:", direction)
	print("Velocity:", velocity)


func _physics_process(delta):
	position += velocity * speed * delta


func _on_Bullet_body_entered(body):
	print("Bullet collided with:", body.name)

	if body.name == "Player":
		print("Hit player — ignored.")
		return

	if body.is_in_group("Enemy") and body.has_method("take_damage"):
		print("Bullet damaging enemy.")
		body.take_damage(10)

		match direction:
			"up": anim.play("bulletimpact_up")
			"down": anim.play("bulletimpact_down")
			"left": anim.play("bulletimpact_left")
			"right": anim.play("bulletimpact_right")

		set_physics_process(false)
		$CollisionShape2D.disabled = true
		yield(anim, "animation_finished")
		queue_free()
	else:
		print("Bullet hit something that is not a damageable enemy.")


func _on_Timer_timeout():
	print("Bullet timed out, removing.")
	queue_free()
