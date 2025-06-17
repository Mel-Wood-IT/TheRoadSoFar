extends Node2D

func _ready():
	var references = [
		{ "name": "Pimen – Fire Spell Effect 02", "link": "https://pimen.itch.io/fire-spell-effect-02" },
		{ "name": "Pimen – Dark Spell Effect", "link": "https://pimen.itch.io/dark-spell-effect" },
		{ "name": "aamatniekss – Topdown Fantasy Forest (Environment)", "link": "https://aamatniekss.itch.io/topdown-fantasy-forest" },
		{ "name": "rowdy41 – Stone Cemetery Asset Pack", "link": "https://rowdy41.itch.io/stone-cemetery-asset-pack" },
		{ "name": "karsiori – Spruce Tree Pack – Pixel Art Animated", "link": "https://karsiori.itch.io/spruce-tree-pack-pixel-art-animated" },
		{ "name": "cuddle-bug – Apocalypse (Player & Bullets)", "link": "https://cuddle-bug.itch.io/apocalypse" },
		{ "name": "foozlecc – Lucifer Necromancer (Possessed Dad)", "link": "https://foozlecc.itch.io/lucifer-necromancer" },
		{ "name": "foozlecc – Lucifer Possessed Enemy (Regular Demon)", "link": "https://foozlecc.itch.io/lucifer-possessed-enemy" },
		{ "name": "lionheart963 – Sorcerer Villain (Knight of Hell)", "link": "https://lionheart963.itch.io/sorcerer-villain" },
		{ "name": "immortal-burrito – Blood Demons (Final Form)", "link": "https://immortal-burrito.itch.io/blood-demons" },
		{ "name": "Heartbeast – RPG Tutorial Series", "link": "https://www.youtube.com/watch?v=mAbG8Oi-SvQ&list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a" },
		{ "name": "Makai Symphony – Boss Battle Theme", "link": "https://makai-symphony.com/9-2/#BossBattle1" },
		{ "name": "Makai Symphony – Main Menu Theme (Horror)", "link": "https://makai-symphony.com/9-2/#Horror" },
		{ "name": "Vecteezy – Pixel Art Tree Icon", "link": "https://www.vecteezy.com/png/13743890-pixel-art-tree-icon" },
		{ "name": "Vecteezy – Pixel Bat Icon", "link": "https://www.vecteezy.com/png/32479655-bat-animal-pixel-art" },
		{ "name": "Pixabay – Bat Chirping", "link": "https://pixabay.com/sound-effects/bat-chirping-type-2-355965/" },
		{ "name": "Pixabay – Demon Pig", "link": "https://pixabay.com/sound-effects/demon-pig-104996/" },
		{ "name": "Pixabay – Knife Stab", "link": "https://pixabay.com/sound-effects/knife-stab-48222/" },
		{ "name": "Pixabay – Pistol Shot", "link": "https://pixabay.com/sound-effects/pistol-shot-233473/" },
		{ "name": "OpenGameArt – Stone Axe with Degradation Progress", "link": "https://opengameart.org/content/stone-axe-with-degradation-progress" },
		{ "name": "OpenGameArt – Footprint Shoeprint Silhouette", "link": "https://opengameart.org/content/footprint-shoeprint-silhouette" },
		{ "name": "OpenGameArt – Long Red Health Bar", "link": "https://opengameart.org/content/long-red-health-bar" },
		{ "name": "OpenGameArt – Enemy Health Bars", "link": "https://opengameart.org/content/enemy-health-bars" },
		{ "name": "OpenGameArt – Golden UI: Bigger Than Ever Edition (Score Panel)", "link": "https://opengameart.org/content/golden-ui-bigger-than-ever-edition" },
		{ "name": "OpenGameArt – RPG UI Pack 1 (HUD Elements)", "link": "https://opengameart.org/content/rpg-ui-1" },
		{ "name": "Google Fonts – Open Source Font Library", "link": "https://fonts.google.com/" },
		{ "name": "OpenGameArt – Smoke Puff Animation", "link": "https://opengameart.org/content/smoke-puff" }

	]

	var container = $ScrollContainer/VBoxContainer

	for ref in references:
		var entry = RichTextLabel.new()
		entry.bbcode_enabled = true
		entry.bbcode_text = "[b]" + ref.name + "[/b]\n" + ref.link
		entry.scroll_active = false
		entry.fit_content_height = true
		entry.rect_min_size.x = 800  # Width to prevent squishing
		container.add_child(entry)

		var spacer = Control.new()
		spacer.rect_min_size.y = 16  # Gap between entries
		container.add_child(spacer)


func _on_BackBtn_pressed():
	get_tree().change_scene("res://Scenes/UI/AboutPage.tscn")
	pass
