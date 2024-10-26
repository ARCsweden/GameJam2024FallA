extends Node2D
class_name Hook

@onready var sprite: Sprite2D = $Sprite2D
@onready var coll: CollisionShape2D = $Sprite2D/Area2D/CollisionShape2D

@export var distance: float = 200.0
@export var speed: float = 0.5

var id: int = 0

var thrown: bool = false
var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	coll.disabled = true

func set_controller_id(controller_id: int) -> void:
	id = controller_id

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !thrown and Input.is_action_just_pressed("hook" + str(id)):
		var target = get_global_mouse_position()
		var dir = (target - get_parent().global_position).normalized()

		sprite.rotation = dir.angle() - PI/2
		visible = true
		thrown = true
		coll.disabled = false
		sprite.position = get_parent().global_position
		tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CIRC)
		tween.tween_property(sprite, "position", dir * distance, speed).as_relative()
		tween.tween_callback(_on_finished)

func _on_finished() -> void:
	visible = false
	thrown = false
	coll.set_deferred("disabled", true)
	if tween:
		tween.kill()


func _on_area_2d_body_entered(body: Node2D) -> void:
	SignalBus.hooked.emit(body)
	_on_finished()
