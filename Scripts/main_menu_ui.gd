extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/difficulty.tscn")

func _on_tutorial_pressed() -> void:
	OS.shell_open("https://docs.google.com/document/d/1-AW1nvLEzTf6L7M68kdvvJQkphw_LXrZ6YgWGZUDCwA/")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func credits():
	OS.shell_open("https://docs.google.com/document/d/1eWvfiP7te0Zjdpcgn5vyqkyOff3nlJ6TJlTzNyRfFPY/")

# OPTIONS LOADING:
func load_settings():
	var file = FileAccess.open("res://settings.dat", FileAccess.READ)
	Global.mastervol = file.get_var(Global.mastervol)
	Global.sfxvol = file.get_var(Global.sfxvol)
	Global.musicvol = file.get_var(Global.musicvol)
	Global.resindex = file.get_var(Global.resindex)
	Global.fsindex = file.get_var(Global.fsindex)
	Global.ChosenSFX = file.get_var(Global.chosen_sfx)
	Global.autosaving = file.get_var(Global.autosave)
	file.close()
	if Global.mastervol != 1:
		mastervolF()
	if Global.sfxvol != 1:
		sfxvolF()
	if Global.musicvol != 1:
		musicvolF()
	if Global.resindex != 0:
		resindexF()
	if Global.fsindex != 0:
		fsindexF()

func mastervolF():
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(Global.mastervol))

func sfxvolF():
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(Global.sfxvol))

func musicvolF():
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(Global.musicvol))

func resindexF():
	match Global.fsindex:
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func fsindexF():
	match Global.resindex:
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))
		3:
			DisplayServer.window_set_size(Vector2i(2560,1440))
		4:
			DisplayServer.window_set_size(Vector2i(3480,2160))
