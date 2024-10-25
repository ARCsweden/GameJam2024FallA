extends Node

# Preloads scene for faster loading
var RaftTileScene := load("res://Scenes/RaftTile.tscn")

var row: int = 3
var column: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_grid()
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _create_grid() -> void:
	#Instantiate tiles in a 3x3 grid.
	var instance
	for r in row:
		print(r)
		for c in column:
			# Creates an instance of RaftTileScene
			instance = RaftTileScene.instantiate() 
			# Adds the instance to the scene tree
			add_child(instance)
			# Moves the instance. +50 is to move the image coordinate to the top left corner
			# Then each instance is moved to the top left corner of the collision shape, to center it
			instance.position = Vector2(r*100+50, c*100+50) - ($RaftCollisionShape.shape.size / 2)
			
	pass
