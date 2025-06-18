extends KinematicBody2D

export(PackedScene) var bat_scene
export (int) var health = 75

onready var sprite = $AnimatedSprite
onready var death_anim = $Death
onready var boss_theme = $MiniBossThemePlayer
onready var attack_timer = $AttackTimer
onready var spawn_points = [$SpawnPoint1, $SpawnPoint2, $SpawnPoint3, $SpawnPoint4]


var cutscene_played = false
var cutscene_skipped = false
var abbadon_alive = true


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


func _on_DetectRadius_body_entered(body):
	if body.name == "Player" and not Global.cutscene_abaddon_finished and not get_node_or_null("AbaddonCutScene"):
		play_cutscene()



func play_cutscene():
	var cutscene = preload("res://Scenes/UI/CutSceneUI.tscn").instance()
	cutscene.connect("cutscene_finished", self, "_on_cutscene_finished")
	get_tree().get_root().add_child(cutscene)
	get_tree().paused = true

func _on_cutscene_finished():
	start_battle()


func start_battle():
	print("STARTING BATTLE...")
	$MiniBossThemePlayer.play()
	$AttackTimer.start()
	sprite.play("Idle")

	

func _on_AttackTimer_timeout():
	if not Global.abaddon_alive: return

	sprite.play("Attack")
	yield(sprite, "animation_finished")
	sprite.play("Idle")

	spawn_bat()


func spawn_bat():
	if bat_scene:
		var bat = bat_scene.instance()
		var point = spawn_points[randi() % spawn_points.size()]
		get_parent().add_child(bat)
		bat.global_position = point.global_position
	else:
		print("bat_scene not assigned!")
		

		
func take_damage(amount):
	if not Global.abaddon_alive:
		return

	health -= amount
	sprite.play("hurt")
	print("Boss took damage:", amount, "| Remaining:", health)

	if health <= 0:
		die()


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




