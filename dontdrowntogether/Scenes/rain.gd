extends CPUParticles2D

var noise := FastNoiseLite.new()
var timer : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Configure
	noise.seed = randi()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	var raftbody_node = get_tree().get_nodes_in_group("RaftBody") 
	var raft = raftbody_node[0]
	var distance = raft.position.y/50

	# Noise is in range [-1, 1] so rotation will be in range [-20, 20]
	rotation_degrees = 20 + 20.0 * noise.get_noise_2d(timer * 5, distance)
	
