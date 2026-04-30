extends Area2D

var word: String
var typed = ""

func set_word(w: String):
	word = w
	$Label.text = word

func _input(event):
	if event is InputEventKey and event.pressed:
		var char = char(event.unicode)
		if char.is_valid_identifier():  # simple check for letters
			typed += char
			update_display()
			if typed == word:
				# word typed correctly!
				queue_free()  # Remove word
				# maybe give player a boost or points
				var player = get_tree().current_scene.get_node("Player")
				if player:
					player.boost_jump()

func update_display():
	$Label.text = word.substr(typed.length())  # Show remaining letters
