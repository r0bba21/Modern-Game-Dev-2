extends Control

@onready var prod_val: Label = $Values/ProdVal
@onready var price_val: Label = $Values/PriceVal
@onready var sales_val: Label = $Values/SalesVal
@onready var fans_val: Label = $Values/FansVal
@onready var exp_val: Label = $Values/ExpVal
@onready var pub_val: Label = $Values/PubVal
@onready var re_val: Label = $Values/ReVal
@onready var cont_val: Label = $Values/ContVal
@onready var loan_val: Label = $Values/LoanVal

func _process(delta: float) -> void:
	prod_val.text = str(Global.prodM)
	price_val.text = str(Global.priceM)
	sales_val.text = str(Global.salesM)
	fans_val.text = str(Global.fansM)
	exp_val.text = str(Global.expM)
	if Global.pubs != true:
		pub_val.text = "Off"
	if Global.pubs == true:
		pub_val.text = "On"
	if Global.resM != true:
		re_val.text = "Off"
	if Global.resM == true:
		re_val.text = "On"
	if Global.conts != true:
		cont_val.text = "Off"
	if Global.conts == true:
		cont_val.text = "On"
	if Global.loans != true:
		loan_val.text = "Off"
	if Global.loans == true:
		loan_val.text = "On"

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

func _on_prod_value_changed(value: float) -> void:
	Global.prodM = value
	soundfx()

func _on_price_value_changed(value: float) -> void:
	Global.priceM = value
	soundfx()

func _on_sales_value_changed(value: float) -> void:
	Global.salesM = value
	soundfx()

func _on_fans_value_changed(value: float) -> void:
	Global.fansM = value
	soundfx()

func _on_exp_value_changed(value: float) -> void:
	Global.expM = value
	soundfx()

func _on_pub_value_changed(value: float) -> void:
	soundfx()
	if value == 1:
		Global.pubs = true
	else:
		Global.pubs = false

func _on_res_value_changed(value: float) -> void:
	soundfx()
	if value == 1:
		Global.resM = true
	else:
		Global.resM = false

func _on_cont_value_changed(value: float) -> void:
	soundfx()
	if value == 1:
		Global.conts = true
	else:
		Global.conts = false

func _on_loans_value_changed(value: float) -> void:
	soundfx()
	if value == 1:
		Global.loans = true
	else:
		Global.loans = false

func _on_play_pressed() -> void:
	soundfx()
	get_tree().change_scene_to_file("res://Scenes/customise.tscn")
