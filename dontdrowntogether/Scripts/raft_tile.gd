extends StaticBody2D

var health = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage():
	set_collision_layer_value(2, true) #Collision layer that shows the tile is damaged
	health -= 1
	if(health == 0):
		destroy()

func destroy():
	self.visible = 0
	set_collision_layer_value(1, true) #Set collision layer to one that collides with a player

func repair():
	self.health = 2
	set_collision_layer_value(2, false)

func rebuild():
	self.visible = 1
	self.health = 2
	set_collision_layer_value(1, false)
