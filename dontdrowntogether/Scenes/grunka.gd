extends RigidBody2D
class_name Grunka

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.hooked.connect(_on_hooked)
	gravity_scale = 0.0

func _on_hooked(body) -> void:
	if body == self:
		queue_free()
