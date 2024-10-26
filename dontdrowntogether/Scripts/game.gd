extends Node2D

# Load the Player scene
var PlayerScene = preload("res://Scenes/player.tscn")

func _ready():
	var spawn_point = Vector2(1000, 500)

	var raft = preload("res://Scenes/Raft.tscn").instantiate()
	raft.position = spawn_point
	add_child(raft)
	#TODO: Get spawnpoints for player 1 and player 2 from raft

	var connected = Input.get_connected_joypads()
	var i = 0
	for joy in connected:
		var player = PlayerScene.instantiate()

		# Set positions or other properties if necessary
		player.position = spawn_point + Vector2(100 + i * 200, 100)  # Adjust as needed
		# Controller ID for this player
		player.set_controller_id(i)
		add_child(player)
		i += 1

func _process(_delta):
	if Input.is_action_just_pressed("OpenCloseMenu"):
		get_tree().quit()
