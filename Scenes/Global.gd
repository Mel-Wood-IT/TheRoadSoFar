extends Node

# Stored variables once player has collected/opened things
var pages_found		= []
var opened_doors	= []
var skull_found		= []


# Track player score
var score := 0
# Max amount of pages to collect
const MAX_PAGES := 3
# Max amount of skulls to collect
const MAX_SKULL := 3

func add_score():
	score += 1
	update_hud()
	
func update_hud():
	var hud = get_current_hud()
	if hud:
		hud.update_score(score)

# Find HUD depending what level the player is on
func get_current_hud():
	for child in get_tree().current_scene.get_children():
		if child is Node2D and child.get_name() == "Main":
			return child
	return null

# Set player health depending on level
func set_health(value):
	var hud = get_current_hud()
	if hud:
		hud.update_health(value)

# Reset just the level
func reset_level():
	pages_found.clear()
	opened_doors.clear()

# Reset the whole game
func reset_game():
	score = 0
	reset_level()
	update_hud()

