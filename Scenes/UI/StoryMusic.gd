extends Node

onready var music_player = AudioStreamPlayer.new()

func _ready():
	# Add and start background music on scene load
	add_child(music_player)
	music_player.stream = preload("res://Resources/Music/Chasing-Villains.mp3")
	music_player.autoplay = true
	
func start_music():
	# Start music manually
	music_player.play()

func stop_music():
	# Stop music manually
	music_player.stop()
