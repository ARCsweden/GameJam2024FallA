extends CanvasLayer

@onready var SinglePlayerButton_Node = %SinglePlayer_TextureButton
@onready var MultiPlayerButton_Node = %Multiplayer_TextureButton2
@onready var QuitButton_Node = %Quit_TextureButton3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SinglePlayerButton_Node.scale = Vector2(.5,.5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_quit_texture_button_3_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_single_player_texture_button_pressed() -> void:
	
	pass # Replace with function body.


func _on_multiplayer_texture_button_2_pressed() -> void:
	
	pass # Replace with function body.
