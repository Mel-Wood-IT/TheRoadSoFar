extends Control

# Restart the level if the player wants to keep trying
func _on_RestartBtn_pressed():
	get_tree().paused = false
	Global.reset_level()
	var current_scene_path = get_tree().current_scene.filename
	get_tree().change_scene(current_scene_path)

# If the player wants to stop, show achievements so far
func _on_AchievementsBtn_pressed():
	get_tree().paused = false
	# Change to achievements page
	get_tree().change_scene("res://Scenes/UI/AchievementPage.tscn")

# Play music only when screen is visible
func _on_GameOverUI_visibility_changed():
	if visible:
		$GameOver.play()
	else:
		$GameOver.stop()
