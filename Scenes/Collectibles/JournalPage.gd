extends Area2D

# If player enters collision shape they collect the journal page
func _on_JournalPage_body_entered(body):
	if body.name == "Player":
		Global.add_score()
		queue_free()
