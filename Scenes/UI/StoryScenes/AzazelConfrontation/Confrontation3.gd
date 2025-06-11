extends Control


func _ready():
	$NextBtn.connect("pressed", self, "_on_NextBtn_pressed")

func _on_NextBtn_pressed():
	Global.cutscene_azazel_finished = true
	get_tree().change_scene("res://Scenes/Levels/LevelFour.tscn") 
