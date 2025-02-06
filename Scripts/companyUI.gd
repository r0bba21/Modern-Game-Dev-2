extends Panel

@onready var comp: Label = $VBoxContainer/Comp
@onready var found: Label = $VBoxContainer/Found
@onready var sold: Label = $VBoxContainer/Sold

@onready var logo: TextureRect = $Control/Logo
@onready var logo_2: TextureRect = $Control/Logo2
@onready var logo_3: TextureRect = $Control/Logo3
@onready var logo_4: TextureRect = $Control/Logo4
@onready var logo_5: TextureRect = $Control/Logo5
@onready var logo_6: TextureRect = $Control/Logo6
@onready var logo_7: TextureRect = $Control/Logo7

func _ready() -> void:
	comp.text = Global.CompName
	found.text = Global.FoundName
	match Global.LogoID:
		0:
			logo.show()
			logo.self_modulate = Global.LogoCOL
		1:
			logo_2.show()
			logo_2.self_modulate = Global.LogoCOL
		2:
			logo_3.show()
			logo_3.self_modulate = Global.LogoCOL
		3:
			logo_4.show()
			logo_4.self_modulate = Global.LogoCOL
		4:
			logo_5.show()
			logo_5.self_modulate = Global.LogoCOL
		5:
			logo_6.show()
			logo_6.self_modulate = Global.LogoCOL
		6:
			logo_7.show()
			logo_7.self_modulate = Global.LogoCOL
