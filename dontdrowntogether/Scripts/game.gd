extends Node2D

# Load the Player scene
var PlayerScene: PackedScene = preload("res://Scenes/player.tscn")
var GrunkaScene: PackedScene = preload("res://Scenes/grunka.tscn")
var RaftScene: PackedScene = preload("res://Scenes/Raft.tscn")
var stone_Scene: PackedScene = preload("res://Scenes/stone.tscn")

var raft: Raft

@onready var grunk_timer: Timer = $GrunkTimer
@onready var hud: HUD = $HUD
@onready var stone_timer : Timer = $StoneTimer

const spawn_point = Vector2(1000, 500)

func _ready():
	Global.scrapAmount = 0

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
	grunk_timer.start(randf_range(Global.grunka_spawn_min, Global.grunka_spawn_max))

	stone_timer.connect("timeout", _on_stone_spawn)
	stone_timer.start(randf_range(Global.stone_spawn_min, Global.stone_spawn_max))

func _on_grunk_spawn() -> void:
	var grunka: Grunka = GrunkaScene.instantiate()
	var value = randi_range(Global.grunka_value_min, Global.grunka_value_max)
	grunka.value = value
	grunka.position = Vector2(randf_range(-1900, 1900), -1000) + raft.position
	grunka.angular_velocity = randf_range(-Global.grunka_ang_vel, Global.grunka_ang_vel)
	grunka.linear_velocity = Vector2(randf_range(-Global.grunka_xvel, Global.grunka_xvel), randf_range(Global.grunka_yvel_min, Global.grunka_yvel_max)) 
	add_child(grunka)
	# Randomize timer
	grunk_timer.start(randf_range(Global.grunka_spawn_min, Global.grunka_spawn_max))

func _on_stone_spawn() -> void:
	var stone = stone_Scene.instantiate()
	stone.position = Vector2(randf_range(-1900, 1900), randf_range(-1000, -1900)) + raft.position
	add_child(stone)
	stone_timer.start(randf_range(Global.stone_spawn_min, Global.stone_spawn_max))

func _on_pickup_grunka(value: int) -> void:
	Global.scrapAmount += value
	hud.update_scrap_Counter(Global.scrapAmount)

func create_player(i: int) -> void:
	var player = PlayerScene.instantiate()
	player.position = Vector2(50,0).rotated(deg_to_rad(90*i))
	# Set positions or other properties if necessary
	#player.position = spawn_point  + Vector2(10 + i * 1, 1)  # Adjust as needed
	# Controller ID for this player
	player.set_controller_id(i)
	raft.add_child(player)

func queuefree_self():
	queue_free()
