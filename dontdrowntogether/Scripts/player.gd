extends CharacterBody2D

@onready var hook: Hook = $Hook

@export var speed: float = 200.0  # Movement speed of the character

var controller_id

var move_up
var move_down
var move_left
var move_right
var paddle
var hook_btn
var controller_ready := false

var cur_dir: Vector2 = Vector2.LEFT

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	rotation = 0 - $"..".rotation #Tries to lock rotation
	# Get input direction
	if controller_ready == true:
		direction = Input.get_vector(move_left, move_right, move_up, move_down).normalized()
	# Update last known facing, used for hook
	if direction != Vector2.ZERO:
		cur_dir = direction

	velocity = direction * speed

	# Move the character
	move_and_slide()


func set_controller_id(id) -> void: 
	controller_id = id
	move_up = "move_up" + str(controller_id)
	move_down = "move_down" + str(controller_id)
	move_right = "move_right" + str(controller_id)
	move_left = "move_left" + str(controller_id)
	paddle = "paddle" + str(controller_id)
	hook_btn = "hook" + str(controller_id)
	controller_ready = true

func _process(_delta) -> void:
	if controller_ready == true:
		if Input.is_action_just_pressed("hook" + str(controller_id)):
			hook.activate_hook(cur_dir)

func repair_raft_tile() -> void:
	pass

func _on_damage_tile_entered(_area):
	$PlayerBoundUi/Label.text = "PRESS [BUTTON] TO REPAIR"
	$PlayerBoundUi/Label.visible = true
	pass

func _on_repair_check_area_area_exited(area: Area2D) -> void:
	$PlayerBoundUi/Label.visible = false
	pass
