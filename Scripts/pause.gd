extends Control

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

@onready var options: Control = $Options

func _on_options_pressed() -> void:
	soundfx()
	options.show()

func _on_bugs_pressed() -> void:
	soundfx()
	OS.shell_open("https://docs.google.com/forms/d/e/1FAIpQLSd4WdRtUWqOTgbtx84H234zPXNA7oHO2jcrWqht6YjOhDGyPA/viewform?usp=sharing")

func _on_tutorial_pressed() -> void:
	soundfx()
	OS.shell_open("https://docs.google.com/document/d/1-AW1nvLEzTf6L7M68kdvvJQkphw_LXrZ6YgWGZUDCwA/")

func _on_main_menu_pressed() -> void:
	soundfx()
	Engine.time_scale = 1
	Global.in_pause = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

@onready var pause: Control = $"."

func _on_resume_pressed() -> void:
	soundfx()
	pause.hide()
	Engine.time_scale = 1
	Global.in_pause = false

@onready var customise: Node2D = $Customise

func _on_custom_pressed() -> void:
	Global.loading_custom = true
	customise.show()
