extends Label

# Speed of writing text
var drawTextSpeed:int = 0

#chatbox character limit
var chatterLimit:int = 300

func _ready():
	pass
	

func _showChatter():
	# Prints out one character at a time
	if drawTextSpeed < chatterLimit:
		drawTextSpeed += 1
		self.visible_characters = drawTextSpeed
	pass
	
func _process(delta):
	_showChatter()
	pass

