extends Area2D

func _on_NextLevel_body_entered(body):
	if body.name == "Player":
		if Global.has_axe and Global.pages_found.has("LevelOne"):
			get_tree().change_scene("res://Scenes/Levels/LevelTwo.tscn")
		else:
			print("You need both the axe and a journal page to proceed")
