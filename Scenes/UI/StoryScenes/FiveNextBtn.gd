extends Button

func _on_NextBtn_pressed():
	StoryMusic.stop_music()
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")
	pass
