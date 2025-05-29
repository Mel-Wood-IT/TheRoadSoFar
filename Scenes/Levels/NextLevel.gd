extends Area2D

# Amount of pages that need to be collected before level change
export(int) var pages_required := 2
# Set next level path
export(String) var next_level_path := "res://Scenes/Levels/LevelThree.tscn"

func _physics_process(delta):
	# Check bodies for player and required pies
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			if Global.pages_found.size() >= pages_required:
				get_tree().change_scene(next_level_path)
