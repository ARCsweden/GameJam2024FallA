#@tool  # Makes the code run in the editor, so we can see the raft
extends RigidBody2D

# Preloads scene for faster loading
var RaftTileScene := load("res://Scenes/RaftTile.tscn")

var rows: int = 5
var columns: int = 5

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
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	paddle()
	if Input.is_action_just_pressed("ui_up"):
		take_damage(2, 2)
	if Input.is_action_just_pressed("ui_down"):
		rebuild_tile(2, 2)


func paddle():
	if Input.is_action_pressed("ui_left"):
		apply_force(Vector2.LEFT*10, position+Vector2.DOWN*150)
	if Input.is_action_pressed("ui_right"):
		apply_force(Vector2.RIGHT*10, position+Vector2.DOWN*150)

func take_damage(r, c):
	grid[r][c].take_damage()

func rebuild_tile(r, c):
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
			# Adds instance to grid so it can edited later
			
			# Creates an invisible layer around the raft to block the player
			if r == 0 or r == rows+1:
				instance.edge_tile()
			if c == 0 or c == columns+1:
				instance.edge_tile()
				
			
			
			grid[r].append(instance)
