extends Node2D

# Load the Player scene
var PlayerScene: PackedScene = preload("res://Scenes/player.tscn")
var GrunkaScene: PackedScene = preload("res://Scenes/grunka.tscn")

@onready var grunk_timer: Timer = $GrunkTimer

const spawn_point = Vector2(1000, 500)

func _ready():
	var raft = preload("res://Scenes/Raft.tscn").instantiate()
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

	# Delay first grunka spawn by a few seconds
	await get_tree().create_timer(3.0).timeout
	grunk_timer.connect("timeout", _on_grunk_spawn)
	grunk_timer.start(randf_range(1.0, 3.0))

func _on_grunk_spawn() -> void:
	var grunka: Grunka = GrunkaScene.instantiate()
	var value = randi_range(1, 5)
	grunka.value = value
	grunka.position = Vector2(randf_range(100, 1900), -100)
	grunka.angular_velocity = randf_range(-1.0, 1.0)
	grunka.linear_velocity = Vector2(randf_range(-50.0, 50.0), randf_range(100.0, 300.0))
	add_child(grunka)
	# Randomize timer
	grunk_timer.start(randf_range(1.0, 3.0))

func create_player(i: int) -> void:
	var player = PlayerScene.instantiate()

	# Set positions or other properties if necessary
	player.position = spawn_point + Vector2(100 + i * 200, 100)  # Adjust as needed
	# Controller ID for this player
	player.set_controller_id(i)
	add_child(player)
	

func _process(_delta):
	if Input.is_action_just_pressed("OpenCloseMenu"):
		get_tree().quit()
	# Temp grunka spawning
	
