extends Node2D


#this all loads main
func _ready():
	pass

func _on_Timer_timeout():
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")
