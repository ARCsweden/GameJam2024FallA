extends StaticBody2D

@onready var hud: HUD = $"../../HUD"

const max_hp := 10.0
var health := 0.0

@onready var decay_timer: Timer = $DecayTimer

#Layer 1: Player collision layer
#Layer 2: Damage taken layer
#Layer 3: Raft layer
#Layer 4: Environment collision layer
#Layer 5: Wall collision layer

func setup_decay_timer() -> void:
	decay_timer.start(randf_range(10.0, 20.0))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_texture()
	
	# Sets raft tile length
	$"./RaftTileCollisionShape".shape.size.x = Global.raft_tile_length
	$"./RaftTileCollisionShape".shape.size.y = Global.raft_tile_length
	# Scales sprite to the raft_tile_length
	_scale_sprite()
	# Instantiate them invisible
	self.visible = 0
	decay_timer.timeout.connect(_on_decay)

func _on_decay() -> void:
	take_damage(1.0)
	if health >= 0.0:
		setup_decay_timer()

func setup_texture():
	# Gives random rotation
	$"./Sprite2D".rotation_degrees = Global.rng.randi_range(0, 3) * 90
	$"./Sprite2D".rotation_degrees += Global.rng.randi_range(-5, 5)
	# Large negative to make sure other items are on top
	$"./Sprite2D".z_index += -50 + Global.rng.randi_range(-1, 1)
	
	
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
	self.visible = 1
	$"./Sprite2D".texture = load("res://icon.svg")
	$"./Sprite2D".flip_v = true

func take_damage(amount):
	$RepairArea.set_collision_layer_value(2, true) #Collision layer that shows the tile is damaged
	health -= amount
	update_color()
	if(health <= 0):
		destroy()

func destroy():
	$Crash_AudioStreamPlayer.play()
	self.visible = 0
	set_collision_layer_value(1, true) #Set collision layer to one that collides with a player
	$RepairArea.set_collision_layer_value(2, false) #Tile is no longer damaged
	set_collision_layer_value(5, false) # Tile no longer collides with walls

func update_color() -> void:
	self.modulate = Color(
		lerp(0.8, 1.0, health / max_hp),
		lerp(0.3, 1.0, health / max_hp),
		lerp(0.3, 1.0, health / max_hp),
		health / max_hp
	)

func repair():
	$Repair_AudioStreamPlayer.play()
	self.health += 1.0
	update_color()
	if health >= max_hp:
		$RepairArea.set_collision_layer_value(2, false)
	Global.scrapAmount -= Global.repair_cost
	hud.update_scrap_Counter(Global.scrapAmount)
	setup_decay_timer()
	

func rebuild():
	self.visible = 1
	self.health = max_hp
	update_color()
	setup_decay_timer()
	set_collision_layer_value(5, true) # tile collides with walls
	set_collision_mask_value(5, true)
	set_collision_layer_value(1, false)
