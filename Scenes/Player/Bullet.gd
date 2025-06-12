extends Area2D

export var speed = 700
var direction = "right"
var velocity = Vector2.ZERO

onready var anim = $BulletAnim

func _ready():
	set_direction(direction)

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
			
			
func _physics_process(delta):
	position += velocity * speed * delta

func _on_Bullet_body_entered(body):
	if body.name == "Player":
		return

	if body.is_in_group("Enemy") and body.has_method("take_damage"):
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
