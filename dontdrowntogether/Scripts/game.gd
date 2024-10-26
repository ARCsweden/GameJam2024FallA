extends Node2D

# Load the Player scene
var PlayerScene = preload("res://Scenes/player.tscn")

func _ready():
	# Create two instances of the Player scene
	var player1 = PlayerScene.instantiate()
	var player2 = PlayerScene.instantiate()

	#TODO: Spawn in raft
	#TODO: Get spawnpoints for player 1 and player 2 from raft
	
	# Set positions or other properties if necessary
	player1.position = Vector2(100, 100)  # Adjust as needed
	player2.position = Vector2(300, 100)  # Adjust as needed
	
	
	add_child(player1)
	add_child(player2)
# Controller ID for this player


func get_unique_controller_id() -> int:
	var connected = Input.get_connected_joypads()
	# Check if there are any connected controllers
	if connected.size() >= 2:
		# Assign the first controller ID to Player 1 and second to Player 2
		if is_instance_valid(self) and is_in_group("Player1"):
			return connected[0]
		else:
			return connected[1]
	else:
		print("Not enough controllers connected!")
		return -1
		
func _process(delta):
	pass
	# Example movement input (adjust based on your input mappings)
	# Add instances to the scene tree
