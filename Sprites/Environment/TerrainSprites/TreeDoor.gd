extends Area2D

func _on_NextLevel_body_entered(body):
	if body.name != "Player":
		return

	var speech_bubble = body.get_node_or_null("SpeechBubble")

	#if player has both axe and pages
	if Global.has_axe and Global.pages_found.has("LevelOne"):
		get_tree().change_scene("res://Scenes/Levels/LevelTwo.tscn")
	
	#if player doesnt have pages
	elif Global.has_axe and not Global.pages_found.has("LevelOne"):
		if speech_bubble:
			speech_bubble.set_text("[color=black]I think I saw one of dad's journal pages around here. I should probably find that first...[/color]")

	#if player doesnt have axe
	elif not Global.has_axe and Global.pages_found.has("LevelOne"):
		if speech_bubble:
			speech_bubble.set_text("[color=black]I should probably find something to clear this...[/color]")

