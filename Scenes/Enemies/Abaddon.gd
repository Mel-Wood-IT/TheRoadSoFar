extends KinematicBody2D

export(PackedScene) var bat_scene
export (int) var health = 75

onready var sprite = $AnimatedSprite
onready var death_anim = $Death
onready var boss_theme = $BossThemePlayer
onready var attack_timer = $AttackTimer
onready var spawn_points = [$SpawnPoint1, $SpawnPoint2, $SpawnPoint3, $SpawnPoint4]
onready var health_bar = $HealthBarUI/BossHealthBar


var cutscene_played = false
var cutscene_skipped = false
var alive = true

func _ready():
	$DetectRadius.connect("body_entered", self, "_on_DetectRadius_body_entered")
	attack_timer.connect("timeout", self, "_on_AttackTimer_timeout")
	sprite.play("idle")
	death_anim.hide()


func _on_DetectRadius_body_entered(body):
	if body.name == "Player" and not cutscene_played and not Global.cutscene_abaddon_finished:
		cutscene_played = true
		play_cutscene()



func play_cutscene():
	var player = get_node("/root/LevelTwo/YSort/Player")
	Global.return_position = player.global_position
	get_tree().change_scene("res://Scenes/UI/StoryScenes/AbaddonCutScene.tscn")

func _on_cutscene_finished():
	start_battle()


func start_battle():
	if health_bar:
		health_bar.max_value = health
		health_bar.value = health
		$HealthBarUI.visible = true
	
	print("STARTING BATTLE...")
	$BossThemePlayer.play()
	$AttackTimer.start()
	sprite.play("Idle")

	



func _on_AttackTimer_timeout():
	if not alive: return

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
	if not alive:
		return

	health -= amount
	if health_bar:
		health_bar.value = health

	if health <= 0:
		die()


func die():
	if not alive:
		return
	alive = false
	$AttackTimer.stop()
	$BossThemePlayer.stop()
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




