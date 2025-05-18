extends StaticBody2D

var on_edge = false


func _on_Edge_body_entered(body: PhysicsBody2D):
	print("Entered by:", body.name)
	on_edge = true

#Dialog for when you done have a key
	if body and body.name == "Player":
		var speech_bubble = body.get_node_or_null("SpeechBubble")
		if speech_bubble:
			speech_bubble.set_text("[color=black]That part of the forest is WAY too dense![/color]")
			

func _on_Edge_body_exited(body):
	on_edge = false
