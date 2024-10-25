extends StaticBody2D

var health = 2

#Layer 1: Player collision layer
#Layer 2: Damage taken layer
#Layer 3: Raft layer
#Layer 4: Environment collision layer
#Layer 5: Wall collision layer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_texture()
	
	# Sets raft tile length
	$"./RaftTileCollisionShape".shape.size.x = Global.raft_tile_length
	$"./RaftTileCollisionShape".shape.size.y = Global.raft_tile_length
	# Scales sprite to the raft_tile_length
	_scale_sprite()
	
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

func take_damage():
	$Area2D.set_collision_layer_value(2, true) #Collision layer that shows the tile is damaged
	self.modulate = Color("8cdada")
	health -= 1
	if(health == 0):
		destroy()

func destroy():
	self.visible = 0
	set_collision_layer_value(1, true) #Set collision layer to one that collides with a player
	$Area2D.set_collision_layer_value(2, false) #Tile is no longer damaged
	set_collision_layer_value(5, false) # Tile no longer collides with walls

func repair():
	self.health = 2
	self.modulate = Color("ffffff")
	$Area2D.set_collision_layer_value(2, false)

func rebuild():
	self.visible = 1
	self.health = 2
	self.modulate = Color("ffffff")
	set_collision_layer_value(5, true) # tile collides with walls
	set_collision_mask_value(5, true)
	set_collision_layer_value(1, false)
