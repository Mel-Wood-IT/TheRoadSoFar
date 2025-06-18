extends KinematicBody2D

# Exported variables
export(PackedScene) var bat_scene
export (int) var health = 100

# On ready variables
onready var sprite = $AnimatedSprite
onready var death_anim = $Death
onready var boss_theme = $MiniBossThemePlayer
onready var attack_timer = $AttackTimer
onready var spawn_points = [$SpawnPoint1, $SpawnPoint2, $SpawnPoint3, $SpawnPoint4]


var cutscene_played = false
var cutscene_skipped = false


# Ready func that loads boss theme, code behind cut scene spawning, detection radius and, some anims
func _ready():
	# Reset health on level reload
	health = 75  
	$MiniBossThemePlayer.stop()
	
	if Global.cutscene_abaddon_finished:
		print("Returned from cutscene, starting battle...")
		start_battle()
		return

	$DetectRadius.connect("body_entered", self, "_on_DetectRadius_body_entered")
	attack_timer.connect("timeout", self, "_on_AttackTimer_timeout")
	sprite.play("Idle")
	death_anim.hide()


# Detection radius for cut scene trigger conditions 
func _on_DetectRadius_body_entered(body):
	if body.name == "Player" and not Global.cutscene_abaddon_finished and not get_node_or_null("AbaddonCutScene"):
		play_cutscene()


# Function for where to find the cut scene
func play_cutscene():
	var cutscene = preload("res://Scenes/UI/CutSceneUI.tscn").instance()
	cutscene.connect("cutscene_finished", self, "_on_cutscene_finished")
	get_tree().get_root().add_child(cutscene)
	get_tree().paused = true


# Function for what to do when the cut scene has finished
func _on_cutscene_finished():
	start_battle()


# Function for what to do when the battle starts like play music and set up attack timer
func start_battle():
	print("STARTING BATTLE...")
	$MiniBossThemePlayer.play()

	$AttackTimer.start()
	sprite.play("Idle")

	
# To avoid looping animations and also to spawn the bats
func _on_AttackTimer_timeout():
	if not Global.abaddon_alive: return

	sprite.play("Attack")
	yield(sprite, "animation_finished")
	sprite.play("Idle")

	spawn_bat()

# where to find the bats to spawn and where to spawn them
func spawn_bat():
	if bat_scene:
		var bat = bat_scene.instance()
		var point = spawn_points[randi() % spawn_points.size()] # Spawn a random amount from 1 - 3
		get_parent().add_child(bat)
		bat.global_position = point.global_position
	else:
		print("bat_scene not assigned!")
		


# Function for what to do when she takes damage and what to do when theres no health left
func take_damage(amount):
	if not Global.abaddon_alive:
		return

	health -= amount
	sprite.play("hurt")
	print("Boss took damage:", amount, "| Remaining:", health)

	if health <= 0:
		die()

# Funtion for dying.
# Here itll save the global var as false, stop the attack timer, theme, and then play the death anim and sound
func die():
	if not Global.abaddon_alive:
		return
	Global.abaddon_alive = false
	$AttackTimer.stop()
	$MiniBossThemePlayer.stop()
	sprite.hide()
	death_anim.show()

	$DeathSound.stream.loop = false
	$DeathSound.play()
	death_anim.play("Death")
	Global.add_score(50)

	yield(death_anim, "animation_finished")
	death_anim.stop()
	death_anim.hide()  # 👈 Hides the final frame
	yield($DeathSound, "finished")
	$DeathSound.stop()

	queue_free()
