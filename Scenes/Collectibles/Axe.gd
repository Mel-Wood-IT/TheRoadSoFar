extends Area2D

func _ready():
	# Hide axe if already picked up
	if Global.has_axe:
		queue_free()

# Validation for collecting the axe, itll disappaer and also change the global variable to change to next level
func _on_Axe_body_entered(body):
	if body.name == "Player":
		Global.has_axe = true
		queue_free()
