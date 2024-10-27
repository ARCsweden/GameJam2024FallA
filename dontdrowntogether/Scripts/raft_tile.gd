extends StaticBody2D

@onready var hud: HUD = $"../../HUD"

var health := 0.0
var collision_scale = 0.9

@onready var decay_timer: Timer = $DecayTimer
@onready var wobbleSprite : Sprite2D = $Sprite2D

@export var top_level_collision_shape: CollisionShape2D

const WOOD_RAFT_TILE : Texture = preload("res://Assets/WoodRaftTile.png")
const BARREL : Texture = preload("res://Assets/Art/Barrel.png")
const BOTTLE_TILE : Texture = preload("res://Assets/BottleTile.png")
var SpriteArrayTexture = [WOOD_RAFT_TILE, BARREL, BOTTLE_TILE]
#Layer 1: Player collision layer
#Layer 2: Damage taken layer
#Layer 3: Raft layer
#Layer 4: Environment collision layer
#Layer 5: Wall collision layer

func setup_decay_timer() -> void:
	decay_timer.start(randf_range(Global.raft_decay_min, Global.raft_decay_max))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_texture()
	set_random_sprite()
	# Sets raft tile length
	$"./RaftTileCollisionShape".shape.size.x = Global.raft_tile_length
	$"./RaftTileCollisionShape".shape.size.y = Global.raft_tile_length
	
	$"./RepairArea/RaftTileCollisionShape".shape.size.x = Global.raft_tile_length*collision_scale
	$"./RepairArea/RaftTileCollisionShape".shape.size.y = Global.raft_tile_length*collision_scale
	
	# Scales sprite to the raft_tile_length
	_scale_sprite()
	# Instantiate sprites disabled and top collision shapes disabled
	top_level_collision_shape.set_deferred("disabled", true)
	$"./Sprite2D".visible = 0
	decay_timer.timeout.connect(_on_decay)

func _on_decay() -> void:
	take_damage(Global.raft_decay_amount)
	if health >= 0.0:
		setup_decay_timer()

func setup_texture():
	# Gives random rotation
	$"./Sprite2D".rotation_degrees = Global.rng.randi_range(0, 3) * 90
	$"./Sprite2D".rotation_degrees += Global.rng.randi_range(-5, 5)
	# Large negative to make sure other items are on top
	$"./Sprite2D".z_index += -5 + Global.rng.randi_range(-1, 1)
	
	
func _scale_sprite():
	var sprite_size: Vector2 = $"./Sprite2D".texture.get_size()
	var new_scale = Vector2(Global.raft_tile_length / sprite_size.x, Global.raft_tile_length / sprite_size.y)
	# Additional scaling to make sure sprite edges don't perfectly connect, it causes visual bug
	$"./Sprite2D".scale = new_scale * 1.25

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func edge_tile():
	set_collision_layer_value(1, true)
	$"./Sprite2D".visible = 1
	self.top_level_collision_shape.set_deferred("disabled", true)
	$"./Sprite2D".texture = load("res://icon.svg")
	$"./Sprite2D".flip_v = true

func take_damage(amount):
	$RepairArea.set_collision_layer_value(2, true) #Collision layer that shows the tile is damaged
	health -= amount
	update_color()
	update_wobble()
	if(health <= 0):
		destroy()

func destroy():
	$Crash_AudioStreamPlayer.play()
	self.top_level_collision_shape.top_level_collision_shape.set_deferred("disabled", true)
	$"./Sprite2D".visible = 0
	set_collision_layer_value(1, true) #Set collision layer to one that collides with a player
	$RepairArea.set_collision_layer_value(2, false) #Tile is no longer damaged
	set_collision_layer_value(5, false) # Tile no longer collides with walls
	
	
func update_color() -> void:
	self.modulate = Color(
		lerp(0.8, 1.0, health / Global.raft_max_hp),
		lerp(0.3, 1.0, health / Global.raft_max_hp),
		lerp(0.3, 1.0, health / Global.raft_max_hp),
		health / Global.raft_max_hp
	)
func update_wobble() -> void:
	wobbleSprite.material.set_shader_parameter("Strength",40-self.health*3.8+2)
	
func repair():
	$Repair_AudioStreamPlayer.play()
	self.health = clampf(health + Global.repair_amount, 0.0, Global.raft_max_hp)
	update_color()
	update_wobble()
	if health >= Global.raft_max_hp:
		$RepairArea.set_collision_layer_value(2, false)
	Global.scrapAmount -= Global.repair_cost
	hud.update_scrap_Counter(Global.scrapAmount)
	setup_decay_timer()
	

func rebuild():
	self.top_level_collision_shape.set_deferred("disabled", false)
	$"./Sprite2D".visible = 1
	self.health = Global.raft_max_hp
	update_color()
	update_wobble()
	setup_decay_timer()
	set_collision_layer_value(5, true) # tile collides with walls
	set_collision_mask_value(5, true)
	set_collision_layer_value(1, false)
	
func set_random_sprite():
	$Sprite2D.texture = SpriteArrayTexture[randi() % SpriteArrayTexture.size() + 0]

	
