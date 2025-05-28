extends Area2D

func _ready():
	# Hide axe if already picked up
	if Global.has_axe:
		queue_free()

func _on_Axe_body_entered(body):
	if body.name == "Player":
		Global.has_axe = true
		queue_free()
