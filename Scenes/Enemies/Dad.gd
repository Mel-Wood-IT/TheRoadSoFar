extends KinematicBody2D

# Exported settings
export (int) var speed = 100
export (int) var health = 1
export (int) var attack_range = 24
export (int) var damage = 10
export (int) var attack_buffer = 4
export (int) var transform_stage = 100

# Internal state
var player = null
var alive = true
var anim_direction = "down"
var animation_locked = false
var attack_in_progress = false
var transformed = false
var retreating = false
var retreat_time = 1.5
var cutscene_played = false
var player_original_position = Vector2.ZERO

var SecondStageBoss = preload("res://Scenes/Enemies/Azazel.tscn")
var BossBatScene = preload("res://Scenes/Enemies/BossBats.tscn")
var DemonScene = preload("res://Scenes/Enemies/Demon.tscn")

onready var sprite = $AnimatedSprite
onready var cooldown = $AttackCooldown
onready var spawn_points = [$SpawnPoint1, $SpawnPoint2, $SpawnPoint3]

func _ready():
	$DetectRadius.connect("body_entered", self, "_on_DetectRadius_body_entered")
	cooldown.connect("timeout", self, "_on_AttackCooldown_timeout")
	sprite.play("idle_down")
	randomize()
	set_physics_process(true)
	sprite.connect("animation_finished", self, "_on_animation_finished")

	# Check for cutscene finish and trigger battle
	if Global.cutscene_azazel_finished:
		player = get_node_or_null("/root/LevelFour/YSort/Player")
		start_battle()



func _physics_process(delta):
	if not alive or player == null or not is_instance_valid(player):
		return

	if animation_locked:
		return

	if retreating:
		var away = (global_position - player.global_position).normalized()
		move_and_slide(away * 200)  # retreat speed
		sprite.play("run_" + anim_direction)
		return

	var to_player = player.global_position - global_position
	var distance = to_player.length()

	# Determine direction
	if abs(to_player.x) > abs(to_player.y):
		anim_direction = "right" if to_player.x > 0 else "left"
	else:
		anim_direction = "down" if to_player.y > 0 else "up"

	if distance > attack_range + attack_buffer:
		move_and_slide(to_player.normalized() * speed)
		sprite.play("run_" + anim_direction)
	else:
		move_and_slide(Vector2.ZERO)
		sprite.play("idle_" + anim_direction)


func _on_animation_finished():
	if sprite.animation.begins_with("attack"):
		var anim_name = sprite.animation
		print("Finished attack animation:", anim_name)

		# Spawn logic based on suffix number
		if anim_name.ends_with("2"):
			spawn_enemy(BossBatScene)
		elif anim_name.ends_with("3"):
			spawn_enemy(DemonScene)
		elif anim_name.ends_with("1"):
			yield(start_retreat(), "completed")
			return  # stop here so retreat handles reset

		# Damage player
		if player and is_instance_valid(player) and alive:
			if global_position.distance_to(player.global_position) <= attack_range + attack_buffer:
				if player.has_method("take_damage"):
					player.take_damage(damage)

		# End attack only for ranged attacks
		if cooldown.is_stopped():
			cooldown.start()
		animation_locked = false
		attack_in_progress = false

	elif sprite.animation.begins_with("hurt"):
		animation_locked = false
		attack_in_progress = false
		if cooldown.is_stopped():
			cooldown.start()
	
		
func spawn_enemy(enemy_scene):
	if not enemy_scene or spawn_points.size() == 0:
		return

	var enemy = enemy_scene.instance()
	var point = spawn_points[randi() % spawn_points.size()]  

	get_parent().add_child(enemy)
	enemy.global_position = point.global_position
	enemy.player = player 


func _on_DetectRadius_body_entered(body):
	if body.name == "Player" and not cutscene_played and not Global.cutscene_azazel_finished:
		player = body
		cutscene_played = true
		play_cutscene()


func take_damage(amount):
	if not alive or transformed:
		return

	health -= amount

	if health <= transform_stage:
		transform()
	else:
		animation_locked = true
		sprite.play("hurt_" + anim_direction)



func _on_AttackCooldown_timeout():
	if not player or not is_instance_valid(player) or not alive:
		return

	var dist = global_position.distance_to(player.global_position)

	if dist <= attack_range + attack_buffer:
		sprite.play("attack_%s1" % anim_direction)
	else:
		var rand_attack = randi() % 2 + 2  # 2 or 3
		sprite.play("attack_%s%d" % [anim_direction, rand_attack])

	attack_in_progress = true
	animation_locked = true

func transform():
	transformed = true
	animation_locked = true

	$AnimatedSprite.hide()
	$Transform.show()
	$Transform.play("transform")
	$Transformation.stream.loop = false
	$Transformation.play()

	# Wait almost to the end (e.g. 1.3 seconds into 1.5 second animation)
	yield(get_tree().create_timer(1.3), "timeout")

	# Spawn second boss just before animation ends
	var new_boss = SecondStageBoss.instance()
	get_parent().add_child(new_boss)
	new_boss.global_position = global_position

	# Wait the rest of the animation before cleaning up
	yield(get_tree().create_timer(0.2), "timeout")

	queue_free()


func start_battle():
	print("STARTING AZAZEL BATTLE...")
	if cooldown.is_stopped():
		cooldown.start()
	$BossThemePlayer.play()


func start_retreat():
	retreating = true
	cooldown.stop()
	yield(get_tree().create_timer(retreat_time), "timeout")
	retreating = false

	animation_locked = false
	attack_in_progress = false
	cooldown.start()
	
func play_cutscene():
	var cutscene = preload("res://Scenes/UI/StoryScenes/AzazelConfrontation/Confrontation1UI.tscn").instance()
	cutscene.connect("cutscene_finished", self, "_on_cutscene_finished")
	get_tree().get_root().add_child(cutscene)

func _on_cutscene_finished():
	start_battle()

