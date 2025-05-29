extends KinematicBody2D

# Movement speed
export var speed = 100
# Health
export var health = 100

# Player states
var alive = true
var current_direction = "front"
var motion = Vector2.ZERO
var is_attacking = false
var is_shooting = false

onready var anim = $Animated

func _ready():
	Global.set_health(health)
	Global.update_pages()
	Global.update_hud()

func _physics_process(delta):
	if not alive:
		return
	handle_input()
	move_and_slide(motion)
	update_animation()
	
func handle_input():
	if is_attacking or is_shooting:
		motion = Vector2.ZERO
		return
	
	motion = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		motion.y -= 1
		current_direction = "back"
	elif Input.is_action_pressed("move_down"):
		motion.y += 1
		current_direction = "front"
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
	if is_attacking:
		anim.play("stab_" + current_direction)
	elif is_shooting:
		anim.play("shoot_" + current_direction)
	elif motion.length() > 0:
		anim.play("walk_" + current_direction)
	else:
		anim.play("idle_" + current_direction)

func stab():
	is_attacking = true
	anim.play("stab_" + current_direction)
	# Wait for a few frames so the animation is visually synced
	yield(get_tree().create_timer(0.1), "timeout")
	# Detect and damage enemies in the stab area
	for body in $StabArea.get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(5)

	yield(anim, "animation_finished")
	is_attacking = false
	
func shoot():
	is_shooting = true
	anim.play("shoot_" + current_direction)
	yield(anim, "animation_finished")
	is_shooting = false

# If not alive, player takes damage that updates the HUD
func take_damage(amount):
	if not alive:
		return
	health -= amount
	health = max(health, 0)
	
	Global.set_health(health)
	
	if health <= 0:
		die()

func die():
	alive = false
	anim.play("death_" + current_direction)
	yield(anim, "animation_finished")
	var game_over = get_tree().get_current_scene().find_node("GameOverUI", true, false)
	if game_over:
		game_over.visible = true
	get_tree().paused = true
	queue_free() # change to game over screen












