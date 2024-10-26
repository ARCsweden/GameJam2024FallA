extends Node2D

# Load the Player scene
var PlayerScene = preload("res://Scenes/player.tscn")

func _ready():
	# Create two instances of the Player scene
	var player1 = PlayerScene.instantiate()
	var player2 = PlayerScene.instantiate()

	# Set positions or other properties if necessary
	player1.position = Vector2(100, 100)  # Adjust as needed
	player2.position = Vector2(300, 100)  # Adjust as needed

	# Add instances to the scene tree
	add_child(player1)
	add_child(player2)
