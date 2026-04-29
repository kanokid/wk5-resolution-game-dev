extends Area2D

func _ready() -> void:
	# Connect the signal that detects when a body enters the area
	body_entered.connect(_on_area_2d_body_entered)

func _on_area_2d_body_entered(body: Node2D) -> void:
	# Check if the object that entered is the Player
	if body.name == "Player":
		game_over()

func game_over() -> void:
	print("Player entered the area! Transporting to Game Over scene...")
	get_tree().change_scene_to_file("res://scenes/youwin.tscn")
