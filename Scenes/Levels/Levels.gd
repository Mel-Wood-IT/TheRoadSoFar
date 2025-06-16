extends Node2D

func _ready():
	print("✅ READY: ", get_tree().current_scene.name)
	print("YSort: ", $YSort)
	print("Player under YSort: ", $YSort.get_node_or_null("Player"))
	print("Camera2D under Player: ", $YSort/Player.get_node_or_null("Camera2D"))
	# Stop story scene music
	StoryMusic.stop_music()
	set_camera_limits()

func set_camera_limits():
	if not $YSort.has_node("Player"):
		print("❌ Player not found under YSort!")
		return

	if not $YSort/Player.has_node("Camera2D"):
		print("❌ Camera2D not found under Player!")
		return

	# Set the camera limits based on base tiles
	var map_limits = $Tilesets/ForestFloor.get_used_rect()
	var map_cellsize = $Tilesets/ForestFloor.cell_size
	$YSort/Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	$YSort/Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	$YSort/Player/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
	$YSort/Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y
