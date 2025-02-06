extends Control

func _ready() -> void:
	check_saves()
	if FileAccess.file_exists("res://settings.dat"):
		load_settings()

@onready var saves: VBoxContainer = $Saves
@onready var play: Button = $VBoxContainer/Play
@onready var load: Button = $VBoxContainer/Load

func _on_play_pressed() -> void:
	soundfx()
	s_1.show()
	s_2.show()
	s_3.show()
	s_4.show()
	s_5.show()
	saves.show()
	play.hide()
	load.hide()

func _on_load_pressed() -> void:
	soundfx()
	check_saves()
	Global.loading_game = true
	saves.show()
	play.hide()
	load.hide()

func _on_tutorial_pressed() -> void:
	soundfx()
	OS.shell_open("https://docs.google.com/document/d/1-AW1nvLEzTf6L7M68kdvvJQkphw_LXrZ6YgWGZUDCwA/")

func _on_options_pressed() -> void:
	soundfx()
	get_tree().change_scene_to_file("res://Scenes/options.tscn")

func _on_quit_pressed() -> void:
	soundfx()
	get_tree().quit()

func credits():
	soundfx()
	OS.shell_open("https://docs.google.com/document/d/1eWvfiP7te0Zjdpcgn5vyqkyOff3nlJ6TJlTzNyRfFPY/")

func bugs():
	soundfx()
	OS.shell_open("https://docs.google.com/forms/d/e/1FAIpQLSd4WdRtUWqOTgbtx84H234zPXNA7oHO2jcrWqht6YjOhDGyPA/viewform?usp=sharing")

@onready var mouse: AudioStreamPlayer2D = $Sounds/Mouse
@onready var dullmouse: AudioStreamPlayer2D = $Sounds/Dullmouse
@onready var filmic: AudioStreamPlayer2D = $Sounds/Filmic
@onready var techno: AudioStreamPlayer2D = $Sounds/Techno
@onready var retro: AudioStreamPlayer2D = $Sounds/Retro

func soundfx():
	match Global.chosen_sfx:
		1:
			mouse.play()
		2:
			dullmouse.play()
		3:
			filmic.play()
		4:
			techno.play()
		5:
			retro.play()

# OPTIONS LOADING:
func load_settings():
	var file = FileAccess.open("res://settings.dat", FileAccess.READ)
	Global.mastervol = file.get_var(Global.mastervol)
	Global.sfxvol = file.get_var(Global.sfxvol)
	Global.musicvol = file.get_var(Global.musicvol)
	Global.resindex = file.get_var(Global.resindex)
	Global.fsindex = file.get_var(Global.fsindex)
	Global.chosen_sfx = file.get_var(Global.chosen_sfx)
	Global.autosave = file.get_var(Global.autosave)
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

# SAVE SLOTS:
@onready var s_1: Button = $Saves/s1
@onready var s_2: Button = $Saves/s2
@onready var s_3: Button = $Saves/s3
@onready var s_4: Button = $Saves/s4
@onready var s_5: Button = $Saves/s5

func check_saves():
	var saves:int = 0
	if FileAccess.file_exists("res://savegame1.dat"):
		s_1.show()
		saves += 1
	if FileAccess.file_exists("res://savegame2.dat"):
		s_2.show()
		saves += 1
	if FileAccess.file_exists("res://savegame3.dat"):
		s_3.show()
		saves += 1
	if FileAccess.file_exists("res://savegame4.dat"):
		s_4.show()
		saves += 1
	if FileAccess.file_exists("res://savegame5.dat"):
		s_5.show()
		saves += 1
	if saves == 0:
		load.hide()

func _on_s_1_pressed() -> void:
	soundfx()
	Global.slot = 1
	match Global.loading_game:
		false:
			get_tree().change_scene_to_file("res://Scenes/difficulty.tscn")
		true:
			get_tree().change_scene_to_file("res://Scenes/customise.tscn")

func _on_s_2_pressed() -> void:
	soundfx()
	Global.slot = 2
	match Global.loading_game:
		false:
			get_tree().change_scene_to_file("res://Scenes/difficulty.tscn")
		true:
			get_tree().change_scene_to_file("res://Scenes/customise.tscn")

func _on_s_3_pressed() -> void:
	soundfx()
	Global.slot = 3
	match Global.loading_game:
		false:
			get_tree().change_scene_to_file("res://Scenes/difficulty.tscn")
		true:
			get_tree().change_scene_to_file("res://Scenes/customise.tscn")

func _on_s_4_pressed() -> void:
	soundfx()
	Global.slot = 4
	match Global.loading_game:
		false:
			get_tree().change_scene_to_file("res://Scenes/difficulty.tscn")
		true:
			get_tree().change_scene_to_file("res://Scenes/customise.tscn")

func _on_s_5_pressed() -> void:
	soundfx()
	Global.slot = 5
	match Global.loading_game:
		false:
			get_tree().change_scene_to_file("res://Scenes/difficulty.tscn")
		true:
			get_tree().change_scene_to_file("res://Scenes/customise.tscn")

func _on_s_6_pressed() -> void: # CANCEL MENU
	soundfx()
	saves.hide()
	Global.loading_game = false
	play.show()
	load.show()
	check_saves()
