extends Area2D

# Required number of journal pages
export(int) var pages_required := 2
# Scene path to next level
export(String) var next_level_path := "res://Scenes/Levels/LevelThree.tscn"
# Optional boss node name to check if still alive
export(String, "") var boss_name := "Abaddon"

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name != "Player":
		return

	# If there's a boss to check, ensure it's dead
	if boss_name != "":
		var boss = get_tree().current_scene.find_node(boss_name, true, false)
		if boss and Global.abaddon_alive:
			_show_speech_bubble(body, "[color=black]I think I saw something back there. I should probably check that out before I keep searching...[/color]")
			return

	# Check if enough pages are collected
	if Global.pages_found.size() >= pages_required:
		get_tree().change_scene(next_level_path)
	else:
		_show_speech_bubble(body, "[color=black]I think I’m missing something... Maybe I should look around more.[/color]")

func _show_speech_bubble(player, text):
	var speech_bubble = player.get_node_or_null("SpeechBubble")
	if speech_bubble:
		speech_bubble.set_text(text)
