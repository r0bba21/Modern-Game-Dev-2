extends Control
# SOUND FX:
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

func chosen_mouse():
	Global.chosen_sfx = 1
	soundfx()

func chosen_dullmouse():
	Global.chosen_sfx = 2
	soundfx()

func chosen_filmic():
	Global.chosen_sfx = 3
	soundfx()

func chosen_techno():
	Global.chosen_sfx = 4
	soundfx()

func chosen_retro():
	Global.chosen_sfx = 5
	soundfx()

# WINDOW:
func res_change(index:int):
	Global.resindex = index
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))
		3:
			DisplayServer.window_set_size(Vector2i(2560,1440))
		4:
			DisplayServer.window_set_size(Vector2i(3480,2160))

func fs_change(index:int):
	Global.fsindex = index
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

# VOLUME:
func master_change(value:float):
	Global.mastervol = value
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	soundfx()

func sfx_change(value:float):
	Global.sfxvol = value
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	soundfx()

func music_change(value:float):
	Global.musicvol = value
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	soundfx()

# AUTOSAVING:
func autosave_change(index:int):
	match index:
		0:
			Global.autosave = 0 # OFF
		1:
			Global.autosave = 1 # ON RELEASE
		2:
			Global.autosave = 2 # ON ESC KEY
		3:
			Global.autosave = 3 # BOTH

# SAVE AND BACK:

@onready var options: Control = $"."

func exit():
	soundfx()
	if Global.in_pause == false:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	if Global.in_pause == true:
		options.hide()

func save_settings():
	var file = FileAccess.open("res://settings.dat", FileAccess.WRITE)
	file.store_var(Global.mastervol)
	file.store_var(Global.sfxvol)
	file.store_var(Global.musicvol)
	file.store_var(Global.resindex)
	file.store_var(Global.fsindex)
	file.store_var(Global.chosen_sfx)
	file.store_var(Global.autosave)
	file.close()
