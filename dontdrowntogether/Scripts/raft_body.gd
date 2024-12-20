#@tool  # Makes the code run in the editor, so we can see the raft
extends RigidBody2D
class_name Raft

# Preloads scene for faster loading
var RaftTileScene := load("res://Scenes/RaftTile.tscn")
var Ripple: PackedScene = preload("res://Scenes/Ripple.tscn")

var rows: int = Global.raft_rows
var columns: int = Global.raft_columns

var raft_max_size = Vector2(Global.raft_tile_length*(columns+3), Global.raft_tile_length*(rows+3))

var starting_area_squares: int = Global.raft_start_radius

var force_mult: float = Global.river_force

var grid = []

# Grid Functionality required: 
#	- Detect when player is on the edge of the grid
#	- Know which tile the player is on
#	- Collision Detection
#	- Destroy tile
#	- Repair tile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Sets max size of the raft
	#$"./RaftCollisionShape".shape.size.x = Global.raft_tile_length*(columns+3)
	#$"./RaftCollisionShape".shape.size.y = Global.raft_tile_length*(rows+3)
	#$"./RaftCollisionShape".position -= Vector2(150, 150)
	add_to_group("RaftBody")
	_create_grid()
	set_collision_layer_value(3, true)
	set_collision_mask_value(3, true)
	_create_starting_area(starting_area_squares)
	SignalBus.paddle.connect(_on_paddle)
	SignalBus.build.connect(_on_build)
	set_axis_velocity(Vector2(0,-200))

	mass = Global.raft_mass
	angular_damp = Global.raft_angular_damping

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	forward_force()
	force_mult += Global.river_acc * delta
	if Input.is_action_just_pressed("DebugRebuild"):
		rebuild_tile(2, 2)

func forward_force():
	var force = Vector2.from_angle(deg_to_rad(rotation_degrees) - deg_to_rad(90))
	apply_central_force(force*force_mult)
	apply_central_force(Vector2.UP*force_mult)

func _on_paddle(player_pos: Vector2, cur_dir: Vector2):
	# Force based on player direction
	apply_force(-cur_dir*Global.paddle_force, player_pos)

func _on_build(player_pos: Vector2, cur_dir: Vector2, current_tile):	
	var raft_rotation = rotation_degrees * (PI / 180)  # Convert degrees to radians
	var rotated_dir = cur_dir.rotated(-raft_rotation)  # Rotate in the opposite direction
	var relative_dir = round_to_nearest_axis(rotated_dir)  # Snap to nearest axis vector
	# Calculate the tile position to build
	var tile_to_build_pos = current_tile.get_grid_pos() + relative_dir
	
	var tile_to_build = grid[tile_to_build_pos.x][tile_to_build_pos.y]
	if tile_to_build.health < 1 and tile_to_build.is_edge_tile == false:
		rebuild_tile(tile_to_build_pos.x, tile_to_build_pos.y)

func round_to_nearest_axis(v: Vector2) -> Vector2:
	# Normalize the vector to get the direction
	if v.length() == 0:
		return Vector2.ZERO  # Return a zero vector if the input is zero

	v = v.normalized()  # Normalize to unit length

	# Determine which axis the vector is closer to
	if abs(v.x) > abs(v.y):
		return Vector2(sign(v.x), 0)  # Return (1, 0) or (-1, 0)
	else:
		return Vector2(0, sign(v.y))  # Return (0, 1) or (0, -1)

func take_damage(r, c, damage):
	grid[r][c].take_damage(damage)

func rebuild_tile(r, c):
	#if (r < rows or c < columns):
	grid[r][c].rebuild()

func repair_tile(r, c):
	grid[r][c].repair()
	

func _create_starting_area(expands):
	# Creates a square of usable tiles around the center
	var center_x: int = ceil(float(rows) / 2)
	var center_y: int = ceil(float(columns) / 2)
	for r in range(center_y - expands, center_y + expands + 1):
		for c in range(center_x - expands, center_x + expands + 1):
			grid[r][c].rebuild()

func _create_grid() -> void:
	#Instantiate tiles in a grid.
	var instance
	for r in rows+2:
		grid.append([])
		for c in columns+2:
			# Creates an instance of RaftTileScene
			instance = RaftTileScene.instantiate() 
			
			# Moves the instance. +50 is to move the image coordinate to the top left corner
			# Then each instance is moved to the top left corner of the collision shape, to center it
			instance.position = Vector2((r+1)*Global.raft_tile_length, (c+1)*Global.raft_tile_length) - (raft_max_size / 2.0) 
			instance.grid_pos = Vector2(r, c)
			
			var collision_shape = CollisionShape2D.new()
			add_child(collision_shape)
			instance.top_level_collision_shape = collision_shape
			collision_shape.shape = instance.get_node("RaftTileCollisionShape").shape
			collision_shape.position = instance.position
			
			# Creates an invisible layer around the raft to block the player
			if r == 0 or r == rows+1:
				instance.edge_tile()
			if c == 0 or c == columns+1:
				instance.edge_tile()

			# Adds the instance to the scene tree
			add_child(instance)
			
			# Adds instance to grid so it can edited later
			grid[r].append(instance)

func nearest_tiles_to_point(point: Vector2, tiles: int) -> Array:
	var nearest_tiles = Array()
	nearest_tiles.resize(tiles)
	var nearest_tile_distances = Array()
	nearest_tile_distances.resize(tiles)
	
	for f in range(tiles):
		nearest_tiles[f] = null
		nearest_tile_distances[f] = 9999
	
	# Finds tiles closest to the stone
	for r in range(grid.size()):
		for c in range(grid[r].size()):
			var tile = grid[r][c]
			if tile.health < 1:
				continue
			
			# Sorts list so when a new minimum is found, it replaces the furthest away tile
			nearest_tile_distances.sort()
			nearest_tile_distances.reverse()
			nearest_tiles.sort()
			nearest_tiles.reverse()
			#print(nearest_tile_distances)
			var tile_distance = tile.global_position.distance_to(point)
			for i in range(nearest_tile_distances.size()):
				if tile_distance < nearest_tile_distances[i]:
					nearest_tile_distances[i] = tile_distance
					nearest_tiles[i] = Vector2(r, c)
					break
	return nearest_tiles

func _on_body_entered(body) -> void:
	# Detect stone
	if body.get_collision_layer() == 132:
		var tiles_to_damage: int = Global.rng.randi_range(Global.stone_damaged_tiles_min, Global.stone_damaged_tiles_max)
		var stone_position = body.global_position
		var nearest_tiles = nearest_tiles_to_point(stone_position, tiles_to_damage)
		for coords in nearest_tiles:
			if coords != null:
				take_damage(coords.x, coords.y, Global.stone_damage)

	if body.name == "LeftWall":
		var left_pos = position + Vector2.LEFT*9999
		var tiles_to_damage: int = Global.rng.randi_range(Global.wall_damaged_tiles_min, Global.wall_damaged_tiles_max)
		var nearest_tiles = nearest_tiles_to_point(left_pos, tiles_to_damage)
		for coords in nearest_tiles:
			if coords != null:
				take_damage(coords.x, coords.y, Global.wall_damage)

	if body.name == "RightWall":
		var left_pos = position + Vector2.RIGHT*9999
		var tiles_to_damage: int = Global.rng.randi_range(Global.wall_damaged_tiles_min, Global.wall_damaged_tiles_max)
		var nearest_tiles = nearest_tiles_to_point(left_pos, tiles_to_damage)
		for coords in nearest_tiles:
			if coords != null:
				take_damage(coords.x, coords.y, Global.wall_damage)


func _on_ripple_timer_timeout():
	var ripple = Ripple.instantiate()
	ripple.lifetime = 5
	ripple.preprocess = 1
	ripple.initial_velocity_min = 50
	ripple.amount = 1000
	ripple.scale_amount_min = 1.5
	
	
	add_child(ripple)
	#ripple.emitting = true
	pass # Replace with function body.
