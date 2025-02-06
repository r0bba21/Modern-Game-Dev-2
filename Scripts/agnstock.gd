extends Panel

@onready var stock_one: Line2D = $StockOne

func _ready() -> void:
	stock_one.clear_points()
	_on_month_timeout()

var x:int = -25
var y:float = 650
var points:int = 0

func _on_month_timeout() -> void:
	x += 50 
	if points >= 21:
		stock_one.remove_point(0)
		stock_one.position.x -= 50
	var last_y = y
	var luck:int = randi_range(1,3)
	match luck:
		1:
			y = randi_range(500,650) # HIGHER Y = LOWER STOCK VALUE
		2:
			y = randi_range(350,500)
		3:
			y = randi_range(200,350)
	stock_one.add_point(Vector2(x, y))
	var style:StyleBoxFlat = load("res://Assets/UI/PRICE.tres") as StyleBoxFlat
	if last_y < y:
		stock_one.default_color = Color("#880023")
		style.bg_color = Color("#880023")
	elif y < last_y:
		stock_one.default_color = Color("#008831")
		style.bg_color = Color("#008831")
	points += 1
	stock_price()

@onready var has_u: Label = $VBoxContainer/HasU
@onready var has_m: Label = $VBoxContainer/HasM
@onready var price_l: Label = $VBoxContainer/PriceL

var price:float
var sum:float = 0
var initial:int = 0

func stock_price():
	var min_value:int = 650
	var max_value:int = 200
	price = ((y - min_value) / (max_value - min_value)) * 25
	price = round(price * 100) / 100 # ROUNDS TO 2DP!
	price_l.text = "$" + str(price)
	var formatted_value:float
	var suffix:String
	if Global.Aunits >= 1000000000:  # B
		formatted_value = round(Global.Aunits / 1000000000.0 * 10) / 10.0
		suffix = "B"
	elif Global.Aunits >= 1000000:  # M
		formatted_value = round(Global.Aunits / 1000000.0 * 10) / 10.0
		suffix = "M"
	elif Global.Aunits >= 1000:  # K
		formatted_value = round(Global.Aunits / 1000.0 * 10) / 10.0
		suffix = "K"
	else: # UNDER 1K:
		formatted_value = round(Global.Aunits * 100.0) / 100
		suffix = ""
	has_u.text = "Units: " + str(formatted_value) + suffix
	sum = Global.Aunits * price
	sum = round(sum * 100) / 100
	var perc:String
	var changeExport:float
	if sum != 0:
		var difference:float = sum - initial
		var change:float = (difference / sum) * 100
		change = round(change * 100) / 100
		if change < 0:
			change = change * -1
		changeExport = change
		var style:StyleBoxFlat = load("res://Assets/UI/PRICE SMALL.tres") as StyleBoxFlat
		print(str(change) + "change")
		if sum >= initial:
			perc = ",  +"
			style.bg_color = Color("#008831")
		elif sum < initial:
			perc = ",  -"
			style.bg_color = Color("#880023")
	var formatted_valueS:float
	var suffixS:String
	if sum >= 1000000000:  # B
		formatted_valueS = round(sum / 1000000000.0 * 10) / 10.0
		suffixS = "B"
	elif sum >= 1000000:  # M
		formatted_valueS = round(sum / 1000000.0 * 10) / 10.0
		suffixS = "M"
	elif sum >= 1000:  # K
		formatted_valueS = round(sum / 1000.0 * 10) / 10.0
		suffixS = "K"
	else: # UNDER 1K:
		formatted_value = sum
		suffix = ""
	has_m.text = "$" + str(formatted_valueS) + suffixS + perc + str(changeExport) + "%"

@onready var buying: LineEdit = $VBoxContainer/Buying

func _on_buying_text_submitted(new_text: String) -> void:
	var considered = int(new_text)
	buying.clear()
	Global.charge += considered
	initial += considered
	print(str(initial) + "initial")
	Global.Aunits += considered / price
	sum = Global.Aunits * price
	soundfx()
	stock_price()

@onready var mouse: AudioStreamPlayer2D = $"../Sounds/Mouse"
@onready var dullmouse: AudioStreamPlayer2D = $"../Sounds/Dullmouse"
@onready var filmic: AudioStreamPlayer2D = $"../Sounds/Filmic"
@onready var techno: AudioStreamPlayer2D = $"../Sounds/Techno"
@onready var retro: AudioStreamPlayer2D = $"../Sounds/Retro"

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

func _on_sale_pressed() -> void:
	if 0 < Global.Aunits:
		Global.charge -= sum * 0.8
		initial = 0
		Global.Aunits = 0
		sum = 0
		soundfx()
		stock_price()
