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
	var luck:int = randi_range(1,10)
	match luck:
		1:
			y = randi_range(550,650) # HIGHER Y = LOWER STOCK VALUE
		2, 3, 4:
			y = randi_range(450,550)
		5, 6, 7:
			y = randi_range(350,450)
		8, 9:
			y = randi_range(250,350)
		10:
			y = randi_range(150,250)
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
var sum:int = 0
var initial:int = 0

func stock_price():
	var min_value:int = 650
	var max_value:int = 150
	price = ((y - min_value) / (max_value - min_value)) * 50
	price = round(price * 100) / 100 # ROUNDS TO 2DP!
	price_l.text = "$" + str(price)
	has_u.text = "Units: " + str(Global.Sunits)
	sum = Global.Sunits * price
	if sum != 0:
		var difference:float = sum - initial
		var change:float = (difference / sum) * 100
		change = round(change * 100) / 100
		if change < 0:
			change = change * -1
		var style:StyleBoxFlat = load("res://Assets/UI/PRICE SMALL.tres") as StyleBoxFlat
		print(str(change) + "change")
		if sum >= initial:
			has_m.text = "$" + str(sum) + ", +" + str(change) + "%"
			style.bg_color = Color("#008831")
		elif sum < initial:
			has_m.text = "$" + str(sum) + ", -" + str(change) + "%"
			style.bg_color = Color("#880023")
	elif sum == 0:
		has_m.text = "$0, +0%"

func _on_selling_text_submitted(new_text: String) -> void:
	var considered = int(new_text)
	Global.charge -= considered * price
	initial -= considered * price
	Global.Sunits -= considered
	sum = Global.Sunits * price
	soundfx()
	stock_price()

func _on_buying_text_submitted(new_text: String) -> void:
	var considered = int(new_text)
	Global.charge += considered * price
	initial += considered * price
	print(str(initial) + "initial")
	Global.Sunits += considered
	sum = Global.Sunits * price
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

@onready var the_bank: Panel = $"../TheBank"
@onready var stocks: Panel = $"."

func _on_take_l_2_pressed() -> void:
	stocks.show()
	the_bank.hide()
	soundfx()
