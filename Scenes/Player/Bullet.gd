# Bullet.gd
extends Area2D

export (int) var speed = 300
var direction = "right"

onready var anim = $AnimatedSprite

func _ready():
	connect("body_entered", self, "_on_Bullet_body_entered")

func _physics_process(delta):
	match direction:
		"up", "back":
			position.y -= speed * delta
		"down", "front":
			position.y += speed * delta
		"left":
			position.x -= speed * delta
		"right":
			position.x += speed * delta

func _on_Bullet_body_entered(body):
	if body.name == "Player":
		return 

	if body.has_method("take_damage"):
		body.take_damage(1)

		match direction:
			"back", "up":
				anim.play("Bulletimpact_up")
			"front", "down":
				anim.play("Bulletimpact_down")
			"left":
				anim.play("Bulletimpact_left")
			"right":
				anim.play("Bulletimpact_right")

		set_physics_process(false)
		$CollisionShape2D.disabled = true
		yield(anim, "animation_finished")
		queue_free()
