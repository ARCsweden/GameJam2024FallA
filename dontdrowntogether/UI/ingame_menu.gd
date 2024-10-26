extends CanvasLayer



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("OpenCloseMenu"):
		if self.visible:
			self.hide()
		else:
			self.show()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mute_music_texture_button_2_pressed() -> void:
	pass # Replace with function body.


func _on_main_menu_texture_button_3_pressed() -> void:
	pass # Replace with function body.


func _on_resume_texture_button_pressed() -> void:
	self.hide()
	pass # Replace with function body.
