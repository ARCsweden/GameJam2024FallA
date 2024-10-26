extends CanvasLayer

@onready var main_menu_scene: PackedScene = load("res://UI/main_menu.tscn")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("OpenCloseMenu"):
		pause_and_unpause()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mute_music_texture_button_2_pressed() -> void:
	pass # Replace with function body.


func _on_main_menu_texture_button_3_pressed() -> void:
	get_tree().call_deferred("change_scene_to_packed", main_menu_scene)
	get_tree().paused = false
	self.get_meta("gameNode").queue_free()
	#queuefreeGame.emit()
	queue_free()

func pause_and_unpause():
	if self.visible:
		get_tree().paused = false
		self.hide()
	else:
		get_tree().paused = true
		self.show()

func _on_resume_texture_button_pressed() -> void:
	pause_and_unpause()
	pass # Replace with function body.
