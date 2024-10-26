extends CharacterBody2D

@export var speed: float = 200.0  # Movement speed of the character

var controller_id

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO

	# Get input direction
	direction.x = Input.get_action_strength("p1_move_right") - Input.get_action_strength("p1_move_left")
	direction.y = Input.get_action_strength("p1_move_down") - Input.get_action_strength("p1_move_up")

	# Normalize direction to have consistent speed in all directions
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	# Move the character
	move_and_slide()


func set_controller_id(id) -> void: controller_id = id
	

func _process(delta) -> void:
	if(Input.get_action_strength("DEBUG") > 0):
		$PlayerBoundUi/Label.visible = true
	else:
		$PlayerBoundUi/Label.visible = false
