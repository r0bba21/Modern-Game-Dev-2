extends Control

func _on_comp_text_changed(new_text: String) -> void:
	Global.CompName = new_text
	soundfx()

func _on_founder_text_changed(new_text: String) -> void:
	Global.FoundName = new_text
	soundfx()

func _on_loc_item_selected(index: int) -> void:
	soundfx()

func _on_logo_item_selected(index: int) -> void:
	Global.LogoID = index
	soundfx()

@onready var mouse: AudioStreamPlayer2D = $"../../Sounds/Mouse"
@onready var dullmouse: AudioStreamPlayer2D = $"../../Sounds/Dullmouse"
@onready var filmic: AudioStreamPlayer2D = $"../../Sounds/Filmic"
@onready var techno: AudioStreamPlayer2D = $"../../Sounds/Techno"
@onready var retro: AudioStreamPlayer2D = $"../../Sounds/Retro"

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

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/office.tscn")
