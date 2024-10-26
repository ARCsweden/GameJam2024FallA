#@tool  # Makes the code run in the editor, so we can see the raft
extends RigidBody2D
class_name Raft

# Preloads scene for faster loading
var RaftTileScene := load("res://Scenes/RaftTile.tscn")

var rows: int = 5
var columns: int = 5

var starting_area_squares: int = 1

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
	$"./RaftCollisionShape".shape.size.x = Global.raft_tile_length*columns
	$"./RaftCollisionShape".shape.size.y = Global.raft_tile_length*rows
	
	_create_grid()
	_create_starting_area(starting_area_squares)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	paddle()
	print(deg_to_rad(rotation_degrees))
	#print(deg_to_rad(position.angle_to_point($"./Sprite2D".position)))
	if Input.is_action_just_pressed("DebugTakeDamage"):
		take_damage(2, 2)
	if Input.is_action_just_pressed("DebugRebuild"):
		rebuild_tile(2, 2)
	if Input.is_action_just_pressed("DebugRepair"):
		repair_tile(2, 2)


func paddle():
	if Input.is_action_pressed("ui_page_up"):
		apply_force(Vector2.LEFT*10, position+Vector2.DOWN*150)
	if Input.is_action_pressed("ui_page_down"):
		apply_force(Vector2.RIGHT*10, position+Vector2.DOWN*150)

func take_damage(r, c):
	grid[r][c].take_damage()

func rebuild_tile(r, c):
	grid[r][c].rebuild()

func repair_tile(r, c):
	grid[r][c].repair()

func _create_starting_area(expands):
	# Creates a square of usable tiles around the center
	var center_x: int = ceil(float(rows) / 2)
	var center_y: int = ceil(float(columns) / 2)
	print(center_x)
	print(center_y)
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
			
			# Adds the instance to the scene tree
			add_child(instance)
			
			# Moves the instance. +50 is to move the image coordinate to the top left corner
			# Then each instance is moved to the top left corner of the collision shape, to center it
			instance.position = Vector2(r*Global.raft_tile_length, c*Global.raft_tile_length) - ($RaftCollisionShape.shape.size / 2.0) - (Vector2(Global.raft_tile_length / 2.0, Global.raft_tile_length / 2.0))
			
			# Creates an invisible layer around the raft to block the player
			if r == 0 or r == rows+1:
				instance.edge_tile()
			if c == 0 or c == columns+1:
				instance.edge_tile()
				
			# Adds instance to grid so it can edited later
			grid[r].append(instance)
