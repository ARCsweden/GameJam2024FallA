extends Node2D
class_name Hook

@onready var sprite: Sprite2D = $Sprite2D

@export var distance: float = 200.0
@export var speed: float = 0.5

var thrown: bool = false
var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# TODO: Separate into a player command? Maybe trigger this from signal instead
	if !thrown and Input.is_action_just_pressed("ui_accept"):
		var target = get_global_mouse_position()
		var dir = (target - global_position).normalized()

		sprite.rotation = dir.angle() - PI/2
		visible = true
		thrown = true
		tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CIRC)
		tween.tween_property(sprite, "position", dir * distance, speed).as_relative()
		tween.tween_callback(_on_finished)

func _on_finished() -> void:
	visible = false
	thrown = false
	if tween:
		tween.kill()
	sprite.position = Vector2.ZERO


func _on_area_2d_body_entered(body: Node2D) -> void:
	SignalBus.hooked.emit(body)
	_on_finished()
