extends KinematicBody2D

export (int) var max_health = 500
var current_health = max_health

onready var anim = $AnimatedSprite
onready var death_anim = $Death
onready var hurtbox = $HurtBox
onready var summon_timer = $SummonTimer
onready var summon_point = $SummonPoint

export (PackedScene) var minion_scene
export (float) var summon_interval = 10.0  # seconds between spawns

func _ready():
	anim.play("Idle")
	death_anim.hide()
	death_anim.scale = Vector2(2, 2)  # Make death animation bigger
	summon_timer.wait_time = summon_interval
	summon_timer.start()
	hurtbox.connect("area_entered", self, "_on_Hurtbox_area_entered")

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("damage"):
		current_health -= 10  # adjust damage as needed
		if current_health <= 0:
			die()

func _on_SummonTimer_timeout():
	anim.play("Attack")
	yield(anim, "animation_finished")
	spawn_minion()
	anim.play("idle")

func spawn_minion():
	if minion_scene:
		var minion = minion_scene.instance()
		get_parent().add_child(minion)
		minion.global_position = summon_point.global_position

func die():
	anim.hide()
	death_anim.show()
	death_anim.play("Death")
	hurtbox.set_deferred("disabled", true)
	summon_timer.stop()
	yield(death_anim, "animation_finished")
	queue_free()

