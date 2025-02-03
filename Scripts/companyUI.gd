extends Panel

@onready var comp: Label = $VBoxContainer/Comp
@onready var found: Label = $VBoxContainer/Found
@onready var sold: Label = $VBoxContainer/Sold
@onready var officeL: Label = $VBoxContainer/Office

@onready var logo: TextureRect = $Control/Logo
@onready var logo_2: TextureRect = $Control/Logo2
@onready var logo_3: TextureRect = $Control/Logo3
@onready var logo_4: TextureRect = $Control/Logo4
@onready var logo_5: TextureRect = $Control/Logo5
@onready var logo_6: TextureRect = $Control/Logo6


func _ready() -> void:
	comp.text = Global.CompName
	found.text = Global.FoundName
	match Global.LogoID:
		0:
			logo.show()
		1:
			logo_2.show()
		2:
			logo_3.show()
		3:
			logo_4.show()
		4:
			logo_5.show()
		5:
			logo_6.show()

func _process(delta: float) -> void:
	sold.text = "Copies Sold: " + str(Global.CopiesSold)
	var office:String
	match Global.office_id:
		0:
			office = "Starter"
		1:
			office = "Amateur"
		2:
			office = "Small"
		3:
			office = "Medium"
		4:
			office = "Large"
		5:
			office = "Skyscraper"
	officeL.text = "Office: " + office
