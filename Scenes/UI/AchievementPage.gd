extends CanvasLayer

func _ready():
	#Titles on the left 
	$VBoxContainer/EnemiesKilledLabel.text = "Score: "
	$VBoxContainer/MiniBossLabel.text = "Abaddon Defeated: " 
	$VBoxContainer/BossLabel.text = "Azazel Defeated: " 
	$VBoxContainer/JournalLabel.text = "Journal Pages: " + "%d/3" % Global.journal_pages_collected.size()
	$VBoxContainer/SkullsLabel.text = "Skulls Found: " + "%d/3" % Global.skull_found.size() 
	
	#The actual count on the right (Hence the two different containers)
	$VBoxContainer2/Score1.text = "%d" % Global.score
	$VBoxContainer2/Score2.text = "%d" % Global.abaddon_score
	$VBoxContainer2/Score3.text = "%d" % Global.azazel_score
	$VBoxContainer2/Score4.text = "%d" % Global.journal_score
	$VBoxContainer2/Score5.text = "%d" % Global.skull_score
	
	#Total Score
	var overall_score = Global.score + Global.abaddon_score + Global.azazel_score + Global.journal_score + Global.skull_score
	$VBoxContainer3/Total.text = "Total: %d" % overall_score

# Takes you back to the menu
func _on_MainMenuBtn_pressed():
	StoryMusic.stop_music()
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")
	pass

