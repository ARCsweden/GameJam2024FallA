@tool  # Makes the code run in the editor, so we can see the raft
extends RigidBody2D

# Preloads scene for faster loading
var RaftTileScene := load("res://Scenes/RaftTile.tscn")

var row: int = 3
var column: int = 3

var grid = []

# Grid Functionality required: 
#	- Detect when player is on the edge of the grid
#	- Know which tile the player is on
#	- Collision Detection
#	- Destroy tile
#	- Repair tile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_grid()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	paddle()
	if Input.is_action_just_pressed("ui_up"):
		destroy_tile(1, 1)
	if Input.is_action_just_pressed("ui_down"):
		repair_tile(1, 1)


func paddle():
	if Input.is_action_pressed("ui_left"):
		apply_force(Vector2.LEFT*10, position+Vector2.DOWN*150)
	if Input.is_action_pressed("ui_right"):
		apply_force(Vector2.RIGHT*10, position+Vector2.DOWN*150)

func destroy_tile(row, col):
	grid[row][col].destroy()

func repair_tile(row, col):
	grid[row][col].repair()

func _create_grid() -> void:
	#Instantiate tiles in a 3x3 grid.
	var instance
	for r in row:
		grid.append([])
		for c in column:
			# Creates an instance of RaftTileScene
			instance = RaftTileScene.instantiate() 
			# Adds the instance to the scene tree
			add_child(instance)
			# Moves the instance. +50 is to move the image coordinate to the top left corner
			# Then each instance is moved to the top left corner of the collision shape, to center it
			instance.position = Vector2(r*100+50, c*100+50) - ($RaftCollisionShape.shape.size / 2)
			# Adds instance to grid so it can edited later
			grid[r].append(instance)
	print(grid)
