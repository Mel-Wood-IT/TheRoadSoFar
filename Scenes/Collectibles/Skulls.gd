extends Area2D

func _ready():
	var level_name = get_tree().current_scene.name
	if Global.skull_found.has(level_name):
		queue_free()

func _on_SkullWhite_body_entered(body):
	if body.name == "Player":
		var level_name = get_tree().current_scene.name
		if not Global.skull_found.has(level_name):
			Global.skull_found[level_name] = true
			
		Global.skills_found(1)
		queue_free()

func _on_SkullYelBlood_body_entered(body):
	if body.name == "Player":
		var level_name = get_tree().current_scene.name
		if not Global.skull_found.has(level_name):
			Global.skull_found[level_name] = true
		
		Global.skills_found(1)
		queue_free()

func _on_SkullWhiBlood_body_entered(body):
	if body.name == "Player":
		var level_name = get_tree().current_scene.name
		if not Global.skull_found.has(level_name):
			Global.skull_found[level_name] = true
			
		Global.skills_found(1)
		queue_free()
