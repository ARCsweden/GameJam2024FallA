extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Sets raft tile length
	$"./RaftTileCollisionShape".shape.size.x = Global.raft_tile_length
	$"./RaftTileCollisionShape".shape.size.y = Global.raft_tile_length
	# Scales sprite to the raft_tile_length
	_scale_sprite()
	
func _scale_sprite():
	var sprite_size: Vector2 = $"./Sprite2D".texture.get_size()
	print(sprite_size)
	var new_scale = Vector2(Global.raft_tile_length / sprite_size.x, Global.raft_tile_length / sprite_size.y)
	print(new_scale)
	# Additional scaling to make sure sprite edges don't perfectly connect, it causes visual bug
	$"./Sprite2D".scale = new_scale * 0.99
	print("Size:", $"./Sprite2D".scale)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func destroy():
	self.visible = 0


func repair():
	self.visible = 1
