extends Node

# Track skulls found
var skull_found = {}
# Check if player has axe
var has_axe := false
# Track pages found
var pages_found := {}
# Track total player score
var score = 0
# Track score per level
var score_per_level = {}

# Max amount of pages to collect
const MAX_PAGES := 3
# Max amount of skulls to collect
const MAX_SKULL := 3

var cutscene_abaddon_finished = false
var azazel_cutscene_played = false
var cutscene_azazel_finished = false
var abaddon_alive = true

var return_position = Vector2()


# Game stats for rewards screen
var mini_boss_killed = false
var boss_killed = false
var journal_pages_collected = []
var skulls_collected = []


func add_score(value = 1):
	var level_name = get_tree().current_scene.name
	# Add to total score
	score += value
	
	# Add to level score
	if not score_per_level.has(level_name):
		score_per_level[level_name] = 0
	score_per_level[level_name] += value
	
	update_hud()

func add_page():
	var level_name = get_tree().current_scene.name
	if not pages_found.has(level_name):
		pages_found[level_name] = true
		update_pages()

func update_pages():
	var hud = get_current_hud()
	if hud:
		hud.update_pages(pages_found.size())

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

# Reset just the current level
func reset_level():
	var current_level = get_tree().current_scene.name
	# Reset axe
	has_axe = false
	# Reset pages
	pages_found.erase(current_level)
	# Reset skulls
	skull_found.erase(current_level)
	
	# Reset level score and subtract from total
	if score_per_level.has(current_level):
		var level_points = score_per_level[current_level]
		score -= level_points
		score = max(score, 0)
		score_per_level.erase(current_level)
	update_pages()
	update_hud()

func award_skull_bonus():
	var skull_count = skull_found.size()
	add_score(skull_count * 20)

# Reset the whole game
func reset_game():
	score = 0
	has_axe = false
	pages_found.clear()
	skull_found.clear()
	reset_level()
	update_hud()

