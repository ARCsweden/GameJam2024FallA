extends Node2D

# Load the Player scene
var PlayerScene: PackedScene = preload("res://Scenes/player.tscn")
var GrunkaScene: PackedScene = preload("res://Scenes/grunka.tscn")
var RaftScene: PackedScene = preload("res://Scenes/Raft.tscn")
var stone_Scene: PackedScene = preload("res://Scenes/stone.tscn")

var raft: Raft
var player_one: Player
var player_two: Player

@onready var grunk_timer: Timer = $GrunkTimer
@onready var hud: HUD = $HUD
@onready var stone_timer : Timer = $StoneTimer

const spawn_point = Vector2(1000, 500)

func _ready():
	raft = RaftScene.instantiate()
	raft.position = spawn_point
	add_child(raft)
	
	var connected = Input.get_connected_joypads()
	var i = 0
	for joy in connected:
		create_player(i)
		i += 1
	if connected.size() == 0:
		create_player(0)
	SignalBus.pickup_grunka.connect(_on_pickup_grunka)

	grunk_timer.connect("timeout", _on_grunk_spawn)
	grunk_timer.start(randf_range(1.5, 3.0))

	stone_timer.connect("timeout", _on_stone_spawn)
	stone_timer.start(randf_range(5.0, 10.0))

func _on_grunk_spawn() -> void:
	var grunka: Grunka = GrunkaScene.instantiate()
	var value = randi_range(1, 5)
	grunka.value = value
	grunka.position = Vector2(randf_range(-1900, 1900), -1000) + raft.position
	grunka.angular_velocity = randf_range(-1.0, 1.0)
	grunka.linear_velocity = Vector2(randf_range(-50.0, 50.0), randf_range(100.0, 300.0)) 
	add_child(grunka)
	# Randomize timer
	grunk_timer.start(randf_range(0.25, 1.0))

func _on_stone_spawn() -> void:
	var stone = stone_Scene.instantiate()
	stone.position = Vector2(randf_range(-1900, 1900), randf_range(-1000, -1900)) + raft.position
	add_child(stone)
	stone_timer.start(randf_range(5.0, 10.0))

func _on_pickup_grunka(value: int) -> void:
	Global.scrapAmount += value
	hud.update_scrap_Counter(Global.scrapAmount)
	if(player_one.last_repairable_tile != null && player_one.can_repair):
		player_one.set_repair(true)
	if(player_two != null && player_two.last_repairable_tile != null && player_two.can_repair):
		player_two.set_repair(true)

func create_player(i: int) -> void:
	var player = PlayerScene.instantiate()

	# Set positions or other properties if necessary
	#player.position = spawn_point  + Vector2(10 + i * 1, 1)  # Adjust as needed
	# Controller ID for this player
	player.set_controller_id(i)
	raft.add_child(player)
	match i:
		0,1: player_one = player
		2: player_two = player

func queuefree_self():
	queue_free()
