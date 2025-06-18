extends Node2D
	

func _on_NextBtn_pressed():
	StoryMusic.stop_music()
	get_tree().change_scene("res://Scenes/UI/AchievementPage.tscn")
	pass # Replace with function body.
