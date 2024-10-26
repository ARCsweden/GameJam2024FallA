extends CharacterBody2D


@export var speed: float = 200.0  # Movement speed of the character

var controller_id

var move_up
var move_down
var move_left
var move_right
var paddle

	
func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO

	# Get input direction
	direction.x = Input.get_action_strength(move_right, controller_id) - Input.get_action_strength(move_left, controller_id)
	direction.y = Input.get_action_strength(move_down, controller_id) - Input.get_action_strength(move_up, controller_id)

	# Normalize direction to have consistent speed in all directions
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	# Move the character
	move_and_slide()


func set_controller_id(id) -> void: 
	controller_id = id
	move_up = "move_up" + str(controller_id)
	move_down = "move_down" + str(controller_id)
	move_right = "move_right" + str(controller_id)
	move_left = "move_left" + str(controller_id)
	paddle = "paddle" + str(controller_id)
		

func _process(_delta) -> void:
	if(Input.get_action_strength("DEBUG",controller_id) > 0):
		$PlayerBoundUi/Label.visible = true
	else:
		$PlayerBoundUi/Label.visible = false

func check_for_damage() -> void:
	
	pass
	
func repair_raft_tile() -> void:
	pass


func _on_area_2d_area_entered(area):
	$PlayerBoundUi/Label.visible = true
	pass # Replace with function body.
