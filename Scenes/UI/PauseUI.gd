extends Control

# set variables to see if paused or not (default not pause)
var is_paused_internal: bool = false
var is_paused:bool setget set_paused

func _ready():
	# Hide help screen by default
	$PauseHelp.visible = false
	$PauseMenu.visible = true
	# Hides menu until opened
	self.visible = false

func _unhandled_input(event):
	# Pressing ESC opens the pause menu
	if event.is_action_pressed("ui_cancel"):
		set_paused(!is_paused_internal)

func set_paused(value: bool) -> void:
	#Pauses game and sets the menu visible
	is_paused_internal = value
	get_tree().paused = is_paused_internal
	self.visible = is_paused_internal
	
	# Play the music for pause screen
	if is_paused_internal:
		$PauseMusic.play()
	else:
		$PauseMusic.stop()


# Functions for buttons
# Resume the game
func _on_ResumeBtn_pressed():
	set_paused(false)

# Restart the level
func _on_RestartBtn_pressed():
	get_tree().paused = false
	Global.restart_level()

# Show the help menu
func _on_HelpBtn_pressed():
	# When opening the help page change visibility
	$PauseMenu.visible = false
	$PauseHelp.visible = true

# Back to main menu
func _on_MainBtn_pressed():
	get_tree().paused = false
	# Reset the game
	Global.reset_game()
	# Change scene to main menu
	get_tree().change_scene("res://Scenes/UI/MainMenu.tscn")

# Back to pause menu from help page
func _on_BackBtn_pressed():
	# When closing the help page change visibility
	$PauseMenu.visible = true
	$PauseHelp.visible = false
