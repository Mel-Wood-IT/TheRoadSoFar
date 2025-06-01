extends Node

onready var music_player = AudioStreamPlayer.new()

func _ready():
	add_child(music_player)
	music_player.stream = preload("res://Resources/Music/Chasing-Villains.mp3")
	music_player.autoplay = true
	
func start_music():
	music_player.play()

func stop_music():
	music_player.stop()
