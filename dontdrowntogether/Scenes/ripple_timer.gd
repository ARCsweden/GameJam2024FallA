extends Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (abs($"..".linear_velocity.y  * 0.012) < 1):
		wait_time = 1
	else:
		wait_time = abs(1 / ( $"..".linear_velocity.y  * 0.012))
		

	
