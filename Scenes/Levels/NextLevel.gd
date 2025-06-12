extends Area2D

# Amount of pages that need to be collected before level change
export(int) var pages_required := 2
# Set next level path
export(String) var next_level_path := "res://Scenes/Levels/LevelThree.tscn"

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name != "Player":
		return

	if Global.abaddon_alive:
		var speech_bubble = body.get_node_or_null("SpeechBubble")
		if speech_bubble:
			speech_bubble.set_text("[color=black]I think I saw something back there, I should probably check that out before I keep searching...[/color]")
		return # stop further execution if boss is still alive

	if Global.pages_found.size() >= pages_required:
		get_tree().change_scene(next_level_path)
