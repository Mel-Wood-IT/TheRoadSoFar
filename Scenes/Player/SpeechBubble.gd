extends Node2D

#assigning variables to the background and text
onready var text_node = $Anchor/RichTextLabel
onready var text_bg = $Anchor/ColorRect

#speed
const char_time = 0.05
const margin_offset = 8

#show it doesnt print anything on spawing
func _ready() -> void:
	visible = false

func set_text(text, wait_time = 3):
	visible = true
	
	# Position above player
	global_position = get_parent().global_position + Vector2(0, -50)
	self.scale = Vector2(0.25, 0.25)

	$Timer.wait_time = wait_time
	$Timer.stop()

	text_node.percent_visible = 0
	text_node.bbcode_text = text
	
	var text_size = text_node.get_font("res://Resources/Fonts/Anton/Anton-Regular.ttf").get_string_size(text_node.text)
	text_node.margin_right = text_size.x + margin_offset

	var duration = 0.4  # Fixed short duration for fast pop-up

	$Tween.remove_all()
	$Tween.interpolate_property(text_node, "percent_visible", 0, 1, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(text_bg, "margin_right", 0, text_size.x + margin_offset, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property($Anchor, "position", Vector2.ZERO, Vector2(-text_size.x / 2, 0), duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()


#hide it once timed out
func _on_Timer_timeout():
	visible = false

func _on_Tween_tween_all_completed():
	$Timer.start()
