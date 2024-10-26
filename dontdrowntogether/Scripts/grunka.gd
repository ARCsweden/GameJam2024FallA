extends RigidBody2D
class_name Grunka

@onready var sprite_2d: Sprite2D = $Sprite2D


const BOTTLE_1 : Texture = preload("res://Assets/Bottle1.png")
const PLANKS : Texture = preload("res://Assets/Art/Planks.png")
const BARREL : Texture = preload("res://Assets/Art/Barrel.png")

var SpriteArrayTexture : Array = [BOTTLE_1, PLANKS, BARREL]
var value: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.hooked.connect(_on_hooked)
	gravity_scale = 0.0
	set_random_sprite()

func _on_hooked(body) -> void:
	if body == self:
		SignalBus.pickup_grunka.emit(value)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # Remove grunkor that are outside the camera

func set_random_sprite():
	
	sprite_2d.texture = SpriteArrayTexture[randi() % SpriteArrayTexture.size() + 0]
