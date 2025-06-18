extends Node2D

# Sets window size to suit the user
func _ready():
	OS.set_window_position(OS.get_screen_size()*0.5 - OS.get_window_size()*0.5)
	pass

# Takes you to the ref page
func _on_RefBtn_pressed():
	get_tree().change_scene("res://Scenes/UI/References.tscn")
	pass

# Back to main menu
func _on_BackBtn_pressed():
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")
	pass
