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

@onready var customise: Node2D = $"../.."

func _on_play_pressed() -> void:
	if Global.loading_custom == false:
		get_tree().change_scene_to_file("res://Scenes/office.tscn")
	else:
		customise.hide()
		Global.loading_custom = false

@onready var logo: TextureRect = $HBoxContainer/Logo
@onready var logo_2: TextureRect = $HBoxContainer/Logo2
@onready var logo_3: TextureRect = $HBoxContainer/Logo3
@onready var logo_4: TextureRect = $HBoxContainer/Logo4
@onready var logo_5: TextureRect = $HBoxContainer/Logo5
@onready var logo_6: TextureRect = $HBoxContainer/Logo6
@onready var logo_7: TextureRect = $HBoxContainer/Logo7

func _on_color_picker_button_color_changed(color: Color) -> void:
	logo.self_modulate = color
	logo_2.self_modulate = color
	logo_3.self_modulate = color
	logo_4.self_modulate = color
	logo_5.self_modulate = color
	logo_6.self_modulate = color
	logo_7.self_modulate = color
	Global.LogoCOL = color

@onready var comp: LineEdit = $VBoxContainer/Label/Comp
@onready var founder: LineEdit = $VBoxContainer/Label2/Founder
@onready var logoP: OptionButton = $VBoxContainer/Label4/Logo
@onready var color_picker_button: ColorPickerButton = $ColorPickerButton

func _ready() -> void:
	if Global.loading_custom == true:
		color_picker_button.color = Global.LogoCOL
		founder.text = Global.FoundName
		comp.text = Global.CompName
		logoP.selected = Global.LogoID
		_on_color_picker_button_color_changed(Global.LogoCOL)
