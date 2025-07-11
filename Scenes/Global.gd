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
# Track Journal Score
var journal_score = 0
# Track skull Score
var skull_score = 0
# Track min boss score
var abaddon_score = 0
# Track boss score
var azazel_score = 0
# Max amount of pages to collect
const MAX_PAGES := 3
# Max amount of skulls to collect
const MAX_SKULL := 3

var cutscene_abaddon_finished = false
var azazel_cutscene_played = false
var cutscene_azazel_finished = false
var abaddon_alive = true


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
	
func journal_score(value = 20):
	# Add to total score
	journal_score += value

func skull_score(value = 25):
	# Add to journal score
	skull_score += value

func abaddon_score(value = 50):
	# add to score
	abaddon_score += value
	
func azazel_score(value = 100):
	# add to score
	azazel_score += value
	

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
	var current_scene = get_tree().current_scene
	var level_name = current_scene.name

	# Stop DadThemePlayer if it exists
	var dad = current_scene.find_node("Dad", true, false)
	if dad and dad.has_node("DadThemePlayer"):
		dad.get_node("DadThemePlayer").stop()
		
	# Stop Azazel music if exists
	var azl = current_scene.find_node("Azazel", true, false)
	if azl and azl.has_node("BossThemePlayer"):
		azl.get_node("BossThemePlayer").stop()

	# Stop Abaddon music if it exists
	var abaddon = current_scene.find_node("Abaddon", true, false)
	if abaddon and abaddon.has_node("MiniBossThemePlayer"):
		abaddon.get_node("MiniBossThemePlayer").stop()

	# Reset abaddon on level 2
	if level_name == "LevelTwo":
		abaddon_alive = true
		cutscene_abaddon_finished = false

	# Reset axe
	has_axe = false
	# Reset pages
	pages_found.erase(level_name)
	skull_found.erase(level_name)
	cutscene_azazel_finished = false

	# Reset level score and subtract from total
	if score_per_level.has(level_name):
		var level_points = score_per_level[level_name]
		score -= level_points
		score = max(score, 0)
		score_per_level.erase(level_name)

	update_pages()
	update_hud()

func restart_level():
	var path = get_tree().current_scene.filename
	Global.reset_level()
	get_tree().change_scene(path)

# how many points per skull you collect
func award_skull_bonus():
	var skull_count = skull_found.size()
	add_score(skull_count * 20)

# Reset the whole game
func reset_game():
	score = 0
	has_axe = false
	cutscene_abaddon_finished = false
	cutscene_azazel_finished = false
	pages_found.clear()
	skull_found.clear()
	reset_level()
	update_hud()

