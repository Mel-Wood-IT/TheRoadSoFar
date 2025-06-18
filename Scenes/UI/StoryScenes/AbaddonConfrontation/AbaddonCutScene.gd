extends Control

# Connecting the next button and itll clear once clicked
func _ready():
	$NextBtn.connect("pressed", self, "_on_NextBtn_pressed")

func _on_NextBtn_pressed():
	get_tree().paused = false
	Global.cutscene_abaddon_finished = true
	queue_free()
