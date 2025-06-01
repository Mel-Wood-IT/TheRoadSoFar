extends Node2D
# This all loads main
func _ready():
	pass
# Timer ends and opens main menu
func _on_Timer_timeout():
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")
