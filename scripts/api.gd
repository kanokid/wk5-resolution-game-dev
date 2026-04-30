
extends Node

@onready var word_http_request = $WordApiRequester
@onready var background_http_request = $BackgroundRequester
var words = []

func _ready():
	word_http_request.request_completed.connect(_on_word_api_requester_request_completed)
	fetch_words()
	background_http_request.request_completed.connect(_on_background_request_completed)
	fetch_background()

func fetch_words():
	var word_url = "https://random-word-api.herokuapp.com/word?number=1"  # Adjust for more words
	word_http_request.request(word_url)

func fetch_background():
	var background_url = "https://picsum.photos/1600/720"
	background_http_request.request(background_url)

func _on_background_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var image = Image.new()
		var error = image.load_jpg_from_buffer(body)
		if error == OK:
			var texture = ImageTexture.create_from_image(image)
			var bg_sprite = get_tree().current_scene.find_child("Background", true, false)
			if bg_sprite:
				bg_sprite.texture = texture
				# Calculate scale to fill the screen
				var screen_size = get_viewport().get_visible_rect().size
				var tex_size = texture.get_size()
				bg_sprite.scale = screen_size / tex_size

func _on_word_api_requester_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		words = json  # Assuming it returns an array of strings
		print("Fetched words: ", words)
		# now, spawn word objects in the game
		spawn_words()
	else:
		print("Failed to fetch words")

func spawn_words():
	for word in words:
		# create a word node (we'll define this next)
		var word_node = preload("res://scenes/word.tscn").instantiate()
		word_node.set_word(word)
		word_node.position = Vector2(50, 50)  # random position
		add_child(word_node)
