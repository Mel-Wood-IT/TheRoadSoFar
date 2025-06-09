extends CanvasLayer

func _ready():
	$VBoxContainer/EnemiesKilledLabel.text = "Enemies Killed: "
	$VBoxContainer/MiniBossLabel.text = "Abaddon Defeated: " 
	$VBoxContainer/BossLabel.text = "Azazel Defeated: " 
	$VBoxContainer/JournalLabel.text = "Journal Pages: "
	$VBoxContainer/SkullsLabel.text = "Skulls Found: " 
	
	$VBoxContainer2/Score1.text = "%d" % Global.enemies_killed
	$VBoxContainer2/Score2.text = str(Global.mini_boss_killed and "Yes" or "No")
	$VBoxContainer2/Score3.text = str(Global.boss_killed and "Yes" or "No")
	$VBoxContainer2/Score4.text = "%d/3" % Global.journal_pages_collected.size()
	$VBoxContainer2/Score5.text = "%d/3" % Global.skull_found.size()


func _on_MainMenuBtn_pressed():
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")
	pass

