extends DirectionalLight2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

const timeout_min : float = 10.0
const timeout_max : float = 30.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(_on_timeout)
	timer.start(randf_range(timeout_min, timeout_max))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_timeout() -> void:
	animation_player.play("strike")
	timer.start(randf_range(timeout_min, timeout_max))
