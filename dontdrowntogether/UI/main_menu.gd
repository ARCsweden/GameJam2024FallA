extends CanvasLayer

@onready var SinglePlayerButton_Node = %Play_TextureButton
@onready var MultiPlayerButton_Node = %Mute_TextureButton2
@onready var QuitButton_Node = %Quit_TextureButton3
@onready var TitleScreenAudioStream_Node = %TitleScreen_AudioStreamPlayer

@onready var game_scene = preload("res://Scenes/game.tscn")
@onready var inGameMenu_scene = load("res://UI/Ingame_menu.tscn")

# Called when the node enters the scene tree for the first time.

func _input(event):
	if event.is_action_pressed("MuteMusic"):
		if TitleScreenAudioStream_Node.playing:
			TitleScreenAudioStream_Node.stop()
		else:
			TitleScreenAudioStream_Node.play()


func _ready() -> void:
	SinglePlayerButton_Node.scale = Vector2(.5,.5)
	pass # Replace with function body.


func _on_quit_texture_button_3_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_play_texture_button_pressed() -> void:
	var newGameScene = game_scene.instantiate()
	var newInGameMenu_scene = inGameMenu_scene.instantiate()
	get_tree().root.add_child(newGameScene)
	get_tree().root.add_child(newInGameMenu_scene)
	
	newInGameMenu_scene.set_meta("gameNode", newGameScene)
	
	self.queue_free()
	pass # Replace with function body.


func _on_mute_texture_button_2_pressed() -> void:
	if TitleScreenAudioStream_Node.playing:
		TitleScreenAudioStream_Node.stop()
	else:
		TitleScreenAudioStream_Node.play()
	pass # Replace with function body.
