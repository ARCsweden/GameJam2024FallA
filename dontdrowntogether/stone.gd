extends StaticBody2D

@onready var collionShape_Node = $CollisionShape2D
@onready var sprite2D_Node = $Sprite2D
#@onready var newCollisionShape2D = CircleShape2D.new()

var randomScale : Vector2
var randomScaleNumber : int = 50
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomScaleNumber =  randi() % 151 + 50
	setup_collision_size()
	setup_texture()
	setup_sprite()

func setup_sprite():
	#set the size of the texture stone to fit the collision
	var sprite_size: Vector2 = sprite2D_Node.texture.get_size()
	sprite2D_Node.scale.x = 2.2*(randomScaleNumber/sprite_size.x)
	sprite2D_Node.scale.y = 2.2*(randomScaleNumber/sprite_size.y)

func setup_texture():
	# Gives random rotation
	sprite2D_Node.rotation_degrees = Global.rng.randi_range(0, 3) * 90
	sprite2D_Node.rotation_degrees += Global.rng.randi_range(-5, 5)
	# Large negative to make sure other items are on top
	sprite2D_Node.z_index += -50 + Global.rng.randi_range(-1, 1)
	
func setup_collision_size():
	#var newCollosion = newCollisionShape2D.instantiate()
	var newCollisionShape2D = CircleShape2D.new()
	newCollisionShape2D.radius = randomScaleNumber
	collionShape_Node.shape = newCollisionShape2D
