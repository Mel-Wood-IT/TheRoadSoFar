extends KinematicBody2D

# === Exported Variables ===
export (int) var speed = 50
<<<<<<< HEAD
export (int) var health = 80
=======
export (int) var health = 100
>>>>>>> 86592b2e79505145543b5318801efd41fee578c6
export (int) var damage = 20
# Triggers spike attack when player in range
export (int) var attack_trigger_range = 96  
# Range of attack
export (int) var attack_radius_range = 48  


onready var anim = $AnimatedSprite
onready var cooldown = $AttackCooldown
onready var theme = $BossThemePlayer
onready var exorcism = $Exorcise


var player = null
var alive = true
var in_attack = false
var facing_left = false
var players_in_attack_radius = []
var is_hurting = false

# === Constants ===
const FLIP_THRESHOLD = 5
const ATTACK_COOLDOWN_TIME = 3.0

# === READY ===
func _ready():
	print("Boss ready")
	cooldown.wait_time = 1.5
	cooldown.one_shot = true
	cooldown.autostart = false

	anim.play("idle")
	exorcism.hide()
	theme.play()


# === PHYSICS ===
func _physics_process(delta):
	if not alive or in_attack or player == null or not is_instance_valid(player):
		return

	var to_player = player.global_position - global_position
	var distance = to_player.length()

	# Flip direction
	var dx = to_player.x
	if dx < -FLIP_THRESHOLD and not facing_left:
		facing_left = true
		scale.x = -1
	elif dx > FLIP_THRESHOLD and facing_left:
		facing_left = false
		scale.x = 1

	# Move until within trigger range
	if distance > attack_trigger_range:
		var move_vec = to_player.normalized() * speed
		move_and_slide(move_vec)
		if anim.animation != "move":
			anim.play("move")
	else:
		# Stop when in range
		move_and_slide(Vector2.ZERO)
		if anim.animation != "idle" and not in_attack:
			anim.play("idle")

		# If not attacking and cooldown is stopped, start attack
		if not in_attack and cooldown.is_stopped():
			start_attack()


func start_attack():
	print("Boss: starting spike_attack")
	print("Players in range:", players_in_attack_radius.size())

	in_attack = true
	anim.play("spike_attack")
	yield(anim, "animation_finished")

	# Damage all valid players still in range
	for p in players_in_attack_radius:
		if p and is_instance_valid(p) and p.has_method("take_damage"):
			print("Boss: dealing", damage, "damage to", p.name)
			p.take_damage(damage)




	in_attack = false
	anim.play("idle")

	# 🔁 Start cooldown AFTER finishing attack
	if cooldown.is_stopped():
		cooldown.start()



# === DAMAGE ===
func take_damage(amount):
	if not alive or is_hurting:
		return

	health -= amount
	is_hurting = true
	anim.play("hurt")
	print("Boss took damage:", amount, "| Remaining:", health)

	yield(anim, "animation_finished")
	is_hurting = false

	if health <= 0:
		die()


func die():
	print("Boss: dying now")
	alive = false

	$Death.stream.loop = false
	$Death.play()

	anim.play("death")  # Start the animation BEFORE hiding
	theme.stop()
	cooldown.stop()

	print("Playing death animation")
	yield(anim, "animation_finished")
	print("Death animation finished")

	anim.hide() 

	yield(get_tree().create_timer(3), "timeout")
	print("Changing scene...")
	get_tree().change_scene("res://Scenes/UI/StoryScenes/StorySix.tscn")

	queue_free()


# === SIGNALS ===
func _on_DetectRadius_body_entered(body):
	if body.name == "Player":
		print("DetectRadius: Player entered")
		player = body

func _on_DetectRadius_body_exited(body):
	if body == player:
		print("DetectRadius: Player exited")
		player = null

func _on_AttackRadius_body_entered(body):
	if body.name == "Player":
		players_in_attack_radius.append(body)

func _on_AttackRadius_body_exited(body):
	if body.name == "Player":
		players_in_attack_radius.erase(body)
		
func _on_AttackCooldown_timeout():
	print("Cooldown Complete")
