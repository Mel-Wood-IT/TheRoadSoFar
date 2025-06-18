extends Area2D

func _ready():
	# Remove skull if already collected in this level
	var level_name = get_tree().current_scene.name
	if Global.skull_found.has(level_name):
		queue_free()

func _on_SkullWhite_body_entered(body):
	# Collect white skull and mark as found
	if body.name == "Player":
		var level_name = get_tree().current_scene.name
		if not Global.skull_found.has(level_name):
			Global.skull_found[level_name] = true
			
		Global.skulls_collected.append(1)
		queue_free()

func _on_SkullYelBlood_body_entered(body):
	# Collect yellow blood skull and mark as found
	if body.name == "Player":
		var level_name = get_tree().current_scene.name
		if not Global.skull_found.has(level_name):
			Global.skull_found[level_name] = true
		
		Global.skulls_collected.append(1)
		queue_free()

func _on_SkullWhiBlood_body_entered(body):
	# Collect white blood skull and mark as found
	if body.name == "Player":
		var level_name = get_tree().current_scene.name
		if not Global.skull_found.has(level_name):
			Global.skull_found[level_name] = true
			
		Global.skulls_collected.append(1)
		queue_free()
