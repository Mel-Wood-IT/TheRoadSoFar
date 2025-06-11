extends Control

func _ready():
	$NextBtn.connect("pressed", self, "_on_NextBtn_pressed")

func _on_NextBtn_pressed():
	get_tree().change_scene("res://Scenes/UI/StoryScenes/AzazelConfrontation/Confrontation3.tscn") 
