extends Node2D
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.position.y = $"../RaftBody".position.y


func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("remove" + str(body))
	body.queue_free()
	pass # Replace with function body.
