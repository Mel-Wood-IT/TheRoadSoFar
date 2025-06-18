extends Node2D

func _ready():
	StoryMusic.stop_music()
	StoryMusic.play_endstory()

func _on_NextBtn_pressed():
	get_tree().change_scene("res://Scenes/UI/StoryScenesGame/StorySeven.tscn")
	pass # Replace with function body.
