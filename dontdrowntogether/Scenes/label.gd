extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



#func get_action_keys_text(action_name: String) -> String:
	#var events = InputMap.get_action_list(action_name)
	#var key_names = []
#
	#for event in events:
		#if event is InputEventKey and event.physical_keycode != 0:
			#var key_name = OS.get_keycode_string(event.physical_keycode)
			#key_names.append(key_name)
		#elif event is InputEventMouseButton:
			#var button_name = "Mouse Button " + str(event.button_index)
			#key_names.append(button_name)
		#elif event is InputEventJoypadButton:
			#var button_name = Input.get_joy_button_string(event.button_index)
			#key_names.append(button_name)
		## Add more event types if necessary (e.g., touch events)
#
	#if key_names.size() == 0:
		#return "[No Key Assigned]"
	#else:
		#return key_names.join(" or ")
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
