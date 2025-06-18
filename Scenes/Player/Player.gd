extends KinematicBody2D

export var speed = 100
export var health = 100
export (PackedScene) var BulletScene

var alive = true
var current_direction = "down"
var motion = Vector2.ZERO
var is_attacking = false
var is_shooting = false

onready var anim = $Animated

func _ready():
	# Initialize health and HUD
	Global.set_health(health)
	Global.update_pages()
	Global.update_hud()

func _physics_process(delta):
	# Handle movement and animation while alive
	if not alive:
		return
	handle_input()
	move_and_slide(motion)
	update_animation()

func handle_input():
	# Read movement and action input
	if is_attacking or is_shooting:
		motion = Vector2.ZERO
		return

	motion = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		motion.y -= 1
		current_direction = "up"
	elif Input.is_action_pressed("move_down"):
		motion.y += 1
		current_direction = "down"

	if Input.is_action_pressed("move_left"):
		motion.x -= 1
		current_direction = "left"
	elif Input.is_action_pressed("move_right"):
		motion.x += 1
		current_direction = "right"

	motion = motion.normalized() * speed

	if Input.is_action_just_pressed("knife"):
		stab()
	elif Input.is_action_just_pressed("shoot"):
		shoot()

func update_animation():
	# Play correct animation based on action/state
	if is_attacking:
		anim.play("stab_" + current_direction)
	elif is_shooting:
		anim.play("shoot_" + current_direction)
	elif motion.length() > 0:
		anim.play("walk_" + current_direction)
	else:
		anim.play("idle_" + current_direction)

func stab():
	# Perform stab attack and damage nearby enemies
	is_attacking = true
	$Stab.stream.loop = false
	$Stab.play()
	anim.play("stab_" + current_direction)
	yield(get_tree().create_timer(0.1), "timeout")

	for body in $StabArea.get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(5)

	yield(anim, "animation_finished")
	is_attacking = false

func shoot():
	# Spawn and fire a bullet in the facing direction
	is_shooting = true
	$Gunshot.stream.loop = false
	$Gunshot.play()
	anim.play("shoot_" + current_direction)

	if BulletScene:
		var bullet = BulletScene.instance()
		bullet.direction = current_direction

		var spawn_node_name = "BulletSpawn_" + current_direction.capitalize()
		if has_node(spawn_node_name):
			var spawn_point = get_node(spawn_node_name)
			bullet.global_position = spawn_point.global_position
		else:
			print("⚠ Could not find spawn point:", spawn_node_name)
			bullet.global_position = global_position

		get_parent().add_child(bullet)

	yield(anim, "animation_finished")
	is_shooting = false

func take_damage(amount):
	# Reduce health and trigger death if needed
	if not alive:
		return
	health -= amount
	Global.set_health(health)

	if health <= 0:
		die()

func die():
	# Handle player death and show game over
	alive = false
	anim.play("death_" + current_direction)

	var boss_theme = get_tree().get_current_scene().find_node("BossThemePlayer", true, false)
	if boss_theme and boss_theme is AudioStreamPlayer:
		boss_theme.stop()

	yield(anim, "animation_finished")

	var game_over = get_tree().get_current_scene().find_node("GameOverUI", true, false)
	if game_over:
		game_over.visible = true

	get_tree().paused = true
	queue_free()
