extends RigidBody2D
class_name Grunka

@onready var sprite_2d: Sprite2D = $Sprite2D
var Ripple: PackedScene = preload("res://Scenes/Ripple.tscn")

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

func _on_hooked(body, player: Node2D) -> void:
	if body == self:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", player.global_position, Global.hook_retract)
		tween.tween_callback(pickup)

func pickup() -> void:
	SignalBus.pickup_grunka.emit(value)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() # Remove grunkor that are outside the camera


func set_random_sprite():
	var randInt : int = randi() % SpriteArrayTexture.size()
	sprite_2d.texture = SpriteArrayTexture[randInt]
	if randInt == 2:
		var newCollisionShape2D = CircleShape2D.new()
		newCollisionShape2D.radius = sprite_2d.texture.get_size().x/40
		$CollisionShape2D.shape = newCollisionShape2D
	if randInt == 1:
		sprite_2d.scale = sprite_2d.transform.get_scale()*2
		
func _process(_delta) -> void:
	
	pass
	
	


func _on_ripple_timer_timeout():
	
	add_child(Ripple.instantiate())
	pass # Replace with function body.


func _on_memory_timer_timeout():
	$RippleTimer.stop()
	pass # Replace with function body.
