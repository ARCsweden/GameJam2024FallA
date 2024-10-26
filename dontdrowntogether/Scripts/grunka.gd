extends RigidBody2D
class_name Grunka

var value: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.hooked.connect(_on_hooked)
	gravity_scale = 0.0

func _on_hooked(body, player: Node2D) -> void:
	if body == self:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", player.global_position, 0.1)
		tween.tween_callback(pickup)

func pickup() -> void:
	SignalBus.pickup_grunka.emit(value)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # Remove grunkor that are outside the camera
