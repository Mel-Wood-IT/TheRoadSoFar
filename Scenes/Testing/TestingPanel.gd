extends Panel

# Called every frame
func _process(delta):
	var current_level = get_tree().current_scene.name
	
	# Update total score
	$Label_TotalScore.text = "Total Score: " + str(Global.score)
	
	# Update level score
	var level_score = 0
	if Global.score_per_level.has(current_level):
		level_score = Global.score_per_level[current_level]
	$Label_LevelScore.text = "Level Score: " + str(level_score)
	
	# Current level name
	$Label_CurrentLevel.text = "Level: " + current_level
	
	# Pages found (total count)
	$Label_Pages.text = "Pages: " + str(Global.pages_found.size()) + " / " + str(Global.MAX_PAGES)
	
	# Skulls found (total count)
	$Label_Skulls.text = "Skulls: " + str(Global.skull_found.size()) + " / " + str(Global.MAX_SKULL)
