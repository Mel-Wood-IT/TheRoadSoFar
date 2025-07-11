extends Node2D

func _ready():
	# Stop story scene music
	StoryMusic.stop_music()
	# Start ambience
	StoryMusic.play_ambience()
	
	set_camera_limits()

func set_camera_limits():
	# Set the camera limits based on base tiles
	var map_limits = $Tilesets/ForestFloor.get_used_rect()
	var map_cellsize = $Tilesets/ForestFloor.cell_size
	$YSort/Player/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	$YSort/Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	$YSort/Player/Camera2D.limit_top = map_limits.position.y * map_cellsize.y
	$YSort/Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y

