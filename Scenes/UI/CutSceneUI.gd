extends CanvasLayer

signal cutscene_finished

func _ready():
	$AudioStreamPlayer.play()

func _on_NextBtn_pressed():
	get_tree().paused = false
	$AudioStreamPlayer.stop()
	emit_signal("cutscene_finished")
	queue_free() 
	Global.cutscene_abaddon_finished = true
