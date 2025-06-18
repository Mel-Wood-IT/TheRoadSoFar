extends Node

onready var music_player = AudioStreamPlayer.new()

var endstory_song = preload("res://Resources/Music/Finale Music.mp3")
var story_song = preload("res://Resources/Music/Chasing-Villains.mp3")
var ambience = preload("res://Resources/Ambience/Game Ambience.wav")

func _ready():
	# Add and start background music on scene load
	add_child(music_player)
	music_player.stream = story_song
	music_player.autoplay = true
	
func play_story():
	music_player.stream = story_song
	music_player.autoplay = true
	music_player.play()

func play_endstory():
	music_player.stream = endstory_song
	music_player.autoplay = true
	music_player.play()

func play_ambience():
	music_player.stream = ambience
	music_player.autoplay = true

func stop_music():
	# Stop music manually
	music_player.stop()
