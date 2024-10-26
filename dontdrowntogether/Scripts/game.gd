extends Node2D

# Load the Player scene
var PlayerScene = preload("res://Scenes/player.tscn")

func _ready():
	# Create two instances of the Player scene
	var player1 = PlayerScene.instantiate()
	var player2 = PlayerScene.instantiate()

	var raft = preload("res://Scenes/player.tscn").instantiate()
	add_child(raft)
	#TODO: Get spawnpoints for player 1 and player 2 from raft
	
	

	# Set positions or other properties if necessary
	player1.position = Vector2(100, 100)  # Adjust as needed
	player2.position = Vector2(300, 100)  # Adjust as needed	
	player1.set_controller_id(get_unique_controller_id(0))
	player2.set_controller_id(get_unique_controller_id(1))
	add_child(player1)
	add_child(player2)
	
# Controller ID for this player


func get_unique_controller_id(player_num) -> int:
	var connected = Input.get_connected_joypads()
	# Check if there are any connected controllers
	if connected.size() >= 2:
			return connected[player_num]
	else:
		print("Un oh, please only connect two controllers")
		get_tree().quit()
		return -1
		
func _process(_delta):
	pass
	# Example movement input (adjust based on your input mappings)
	# Add instances to the scene tree
