extends Node2D

func _ready():
	# Passes the global score count
	update_score(Global.score)

# Searches for Score label and sets new score
func update_score(value):
	var score_label = find_node("Score", true, false)
	if score_label:
		score_label.text = str(value)

# Updates healthbar texture when value is changed
func _on_HealthProgress_value_changed(value):
	if $HUD.has_node("HealthProgress"):
		$HUD/HealthProgress.value = value

# Updates health from player script
func update_health(value):
	var hp_bar = find_node("HealthProgress", true, false)
	if hp_bar:
		hp_bar.value = value

# Updates pageprogress texture when value is changed
func _on_PageProgress_value_changed(value):
	if $HUD/ScoreCard.has_node("PageProgress"):
		$HUD/ScoreCard/PageProgress.value = value
# Updated the amount of pages collected
func update_pages(value):
	var page_bar = find_node("PageProgress", true, false)
	if page_bar:
		page_bar.value = value
