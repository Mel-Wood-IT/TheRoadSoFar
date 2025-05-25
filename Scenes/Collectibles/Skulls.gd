extends Area2D

func _on_SkullWhite_body_entered(body):
	if body.name == "Player":
		queue_free()

func _on_SkullYelBlood_body_entered(body):
	if body.name == "Player":
		queue_free()

func _on_SkullWhiBlood_body_entered(body):
	if body.name == "Player":
		queue_free()
