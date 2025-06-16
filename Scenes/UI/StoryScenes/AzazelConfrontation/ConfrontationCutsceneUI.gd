extends CanvasLayer

signal cutscene_finished

# Export the next cutscene
export (PackedScene) var next_cutscene
export (bool) var is_final_cutscene = false

func _ready():
	get_tree().paused = true

func _on_NextBtn_pressed():
	if is_final_cutscene:
		get_tree().paused = false
		Global.cutscene_azazel_finished = true
		emit_signal("cutscene_finished")
		queue_free()
	else:
		if next_cutscene:
			var next = next_cutscene.instance()
			next.connect("cutscene_finished", self, "_on_cutscene_finished_from_next")
			get_tree().get_root().add_child(next)
		queue_free()

# In case we want to react after the whole chain ends
func _on_cutscene_finished_from_next():
	emit_signal("cutscene_finished")
