extends Node2D

# Sets window size to suit the user
func _ready():
	OS.set_window_position(OS.get_screen_size()*0.5 - OS.get_window_size()*0.5)
	pass


# Button to play the game
func _on_PlayBtn_pressed():
	get_tree().change_scene("res://Scenes/Levels/Level One.tscn")
	pass # Replace with function body.

# Button to open about page
func _on_AboutBtn_pressed():
	get_tree().change_scene("res://Scenes/UI/AboutPage.tscn")
	pass

# Button to open help page
func _on_HelpBtn_pressed():
	get_tree().change_scene("res://Scenes/UI/HelpPage.tscn")
	pass

# Button to view story
func _on_StoryBtn_pressed():
	get_tree().change_scene("res://Scenes/UI/StoryScenes/StoryOne.tscn")
	pass

# Button to exit the game
func _on_ExitBtn_pressed():
	get_tree().quit()
	pass
