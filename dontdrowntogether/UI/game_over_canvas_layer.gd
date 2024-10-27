extends CanvasLayer

@onready var main_menu_scene: PackedScene = load("res://UI/main_menu.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_texture_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_packed", main_menu_scene)
	get_tree().paused = false
	for i in get_tree().get_root().get_children():
		if i.name == "Game" or i.name == "Menu_CanvasLayer":
			i.queue_free()
	get_tree().call_deferred("change_scene_to_packed", main_menu_scene)
	queue_free()
	
	pass # Replace with function body.