extends CPUParticles2D

func _ready():
	one_shot=true
	emitting=true



func _on_finished():
	one_shot=false
	emitting=false
	queue_free()
	#print(self.name + " died") # Replace with function body.
