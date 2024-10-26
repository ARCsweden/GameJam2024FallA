extends Node2D

# Load the Player scene
var PlayerScene = preload("res://Scenes/player.tscn")
var raft = preload("res://Scenes/Raft.tscn")

const spawn_point = Vector2(1000, 500)

func _ready():
	raft = raft.instantiate()
	raft.position = spawn_point
	add_child(raft)
	#TODO: Get spawnpoints for player 1 and player 2 from raft

	var connected = Input.get_connected_joypads()
	var i = 0
	for joy in connected:
		create_player(i)
		i += 1
	if connected.size() == 0:
		create_player(0)

func create_player(i: int) -> void:
	var player = PlayerScene.instantiate()

	# Set positions or other properties if necessary
	# player.position = spawn_point  + Vector2(10 + i * 1, 1)  # Adjust as needed
	# Controller ID for this player
	player.set_controller_id(i)
	raft.add_child(player)
	

func _process(_delta):
	if Input.is_action_just_pressed("OpenCloseMenu"):
		get_tree().quit()
