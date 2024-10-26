extends RigidBody2D
class_name Grunka

var value: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.hooked.connect(_on_hooked)
	gravity_scale = 0.0

func _on_hooked(body) -> void:
	if body == self:
		SignalBus.pickup_grunka.emit(value)
		queue_free()
