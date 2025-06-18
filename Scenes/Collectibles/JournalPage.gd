extends Area2D

func _ready():
	# Hide page if already collected
	var level_name = get_tree().current_scene.name
	if Global.pages_found.has(level_name):
		queue_free() 

# If player enters collision shape they collect the journal page
func _on_JournalPage_body_entered(body):
	if body.name == "Player":
		Global.add_page()
		Global.journal_pages_collected.append(1)
		Global.journal_score()
		
		queue_free()
