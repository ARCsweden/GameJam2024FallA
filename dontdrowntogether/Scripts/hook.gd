extends Node2D
class_name Hook

@onready var sprite: Sprite2D = $Sprite2D
@onready var coll: CollisionShape2D = $Area2D/CollisionShape2D
@onready var hook_audio_stream_player: AudioStreamPlayer = $Hook_AudioStreamPlayer

var distance: float = Global.hook_distance
var speed: float = Global.hook_speed

var thrown: bool = false
var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	coll.disabled = true

func activate_hook(dir: Vector2) -> void:
	if !thrown:
		rotation = dir.angle() - PI/2
		visible = true
		thrown = true
		coll.disabled = false
		position = get_parent().global_position
		tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CIRC)
		tween.tween_property(self, "position", dir * distance, speed).as_relative()
		tween.tween_callback(_on_finished)
		hook_audio_stream_player.play()

func _on_finished() -> void:
	visible = false
	thrown = false
	coll.set_deferred("disabled", true)
	if tween:
		tween.kill()


func _on_area_2d_body_entered(body: Node2D) -> void:
	SignalBus.hooked.emit(body, get_parent())
	tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", get_parent().global_position, Global.hook_retract)
	tween.tween_callback(_on_finished)
