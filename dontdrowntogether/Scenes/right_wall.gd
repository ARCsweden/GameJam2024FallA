extends CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_scale_sprite()
	$"..".constant_linear_velocity = -Global.wall_bounce

func _scale_sprite():
	var sprite_size: Vector2 = $"./Sprite2D".texture.get_size()
	var new_scale = Vector2(shape.size.x / sprite_size.x,shape.size.y / sprite_size.y)
	# Additional scaling to make sure sprite edges don't perfectly connect, it causes visual bug
	$"./Sprite2D".scale = new_scale
