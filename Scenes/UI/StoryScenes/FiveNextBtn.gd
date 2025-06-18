extends Button

#where the next button takes you
func _on_NextBtn_pressed():
	StoryMusic.stop_music()
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")
	
