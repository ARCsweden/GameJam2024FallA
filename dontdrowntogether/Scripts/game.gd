extends Node2D

# Load the Player scene
var PlayerScene: PackedScene = preload("res://Scenes/player.tscn")
var GrunkaScene: PackedScene = preload("res://Scenes/grunka.tscn")
var RaftScene: PackedScene = preload("res://Scenes/Raft.tscn")

var raft: Raft

@onready var grunk_timer: Timer = $GrunkTimer
@onready var hud: HUD = $HUD

const spawn_point = Vector2(1000, 500)

func _ready():
	raft = RaftScene.instantiate()
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
	SignalBus.pickup_grunka.connect(_on_pickup_grunka)

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

func _on_pickup_grunka(value: int) -> void:
	Global.scrapAmount += value
	hud.update_scrap_Counter(Global.scrapAmount)

func create_player(i: int) -> void:
	var player = PlayerScene.instantiate()

	# Set positions or other properties if necessary
	# player.position = spawn_point  + Vector2(10 + i * 1, 1)  # Adjust as needed
	# Controller ID for this player
	player.set_controller_id(i)
	raft.add_child(player)

func queuefree_self():
	queue_free()
