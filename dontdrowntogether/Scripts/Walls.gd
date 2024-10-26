extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_scale_sprite()

func _scale_sprite():
	var sprite_size: Vector2 = $"./LeftWall/Sprite2D".texture.get_size()
	var new_scale = Vector2($"./LeftWall".shape.size.x / sprite_size.x, $"./LeftWall".shape.size.y / sprite_size.y)
	# Additional scaling to make sure sprite edges don't perfectly connect, it causes visual bug
	$"./LeftWall/Sprite2D".scale = new_scale
	
	sprite_size = $"./RightWall/Sprite2D".texture.get_size()
	new_scale = Vector2($"./RightWall".shape.size.x / sprite_size.x, $"./RightWall".shape.size.y / sprite_size.y)
	# Additional scaling to make sure sprite edges don't perfectly connect, it causes visual bug
	$"./RightWall/Sprite2D".scale = new_scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
