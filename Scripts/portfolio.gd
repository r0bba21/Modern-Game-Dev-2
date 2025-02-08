extends HBoxContainer

@onready var nameBox: VBoxContainer = $NAME
@onready var unitsBox: VBoxContainer = $UNITS
@onready var qualityBox: VBoxContainer = $QUALITY
@onready var revenueBox: VBoxContainer = $REVENUE

var label_theme:Theme = Theme.new()

func _process(delta: float) -> void:
	add_name()
	add_units()
	add_qual()
	add_rev()
	calc_average()

func add_name():
	if Global.LatestName != "?":
		var label:Label = Label.new()
		label.text = " " + Global.LatestName + " "
		Tot += 0.25
		Global.LatestName = "?"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		var themeN = Theme.new()
		themeN.set_constant("outline_size", "Label", 8)
		var cusFont = load("res://Assets/UI/NewyearCoffee-4nd2D.ttf") as FontFile
		if cusFont:
			themeN.set_font("font", "Label", cusFont)
		themeN.set_color("font_outline_color", "Label", Color.BLACK)
		themeN.set_font_size("font_size", "Label", 30)
		label.theme = themeN
		var stylebox = load("res://Assets/UI/portfolio.tres") as StyleBox
		if stylebox:
			label.add_theme_stylebox_override("normal", stylebox)
		nameBox.add_child(label)

func add_units():
	if Global.LatestUnits != 0:
		var label:Label = Label.new()
		SumUnits += Global.LatestUnits
		Tot += 0.25
		label.text = " " + str(Global.LatestUnits) + " "
		Global.LatestUnits = 0
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		var themeN = Theme.new()
		themeN.set_constant("outline_size", "Label", 8)
		var cusFont = load("res://Assets/UI/NewyearCoffee-4nd2D.ttf") as FontFile
		if cusFont:
			themeN.set_font("font", "Label", cusFont)
		themeN.set_color("font_outline_color", "Label", Color.BLACK)
		themeN.set_font_size("font_size", "Label", 30)
		label.theme = themeN
		var stylebox = load("res://Assets/UI/portfolio.tres") as StyleBox
		if stylebox:
			label.add_theme_stylebox_override("normal", stylebox)
		unitsBox.add_child(label)
		calc_average()

func add_qual():
	if Global.LatestQual != 0:
		var label:Label = Label.new()
		SumQual += Global.LatestQual
		Tot += 0.25
		label.text = " " + str(round((Global.LatestQual) * 100) / 100) + " "
		Global.LatestQual = 0
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		var themeN = Theme.new()
		themeN.set_constant("outline_size", "Label", 8)
		var cusFont = load("res://Assets/UI/NewyearCoffee-4nd2D.ttf") as FontFile
		if cusFont:
			themeN.set_font("font", "Label", cusFont)
		themeN.set_color("font_outline_color", "Label", Color.BLACK)
		themeN.set_font_size("font_size", "Label", 30)
		label.theme = themeN
		var stylebox = load("res://Assets/UI/portfolio.tres") as StyleBox
		if stylebox:
			label.add_theme_stylebox_override("normal", stylebox)
		qualityBox.add_child(label)
		calc_average()

func add_rev():
	if Global.LatestRev != 0:
		var label:Label = Label.new()
		SumRev += Global.LatestRev
		Tot += 0.25
		label.text = "$" + str(Global.LatestRev) + " "
		Global.LatestRev = 0
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		var themeN = Theme.new()
		themeN.set_constant("outline_size", "Label", 8)
		var cusFont = load("res://Assets/UI/NewyearCoffee-4nd2D.ttf") as FontFile
		if cusFont:
			themeN.set_font("font", "Label", cusFont)
		themeN.set_color("font_outline_color", "Label", Color.BLACK)
		themeN.set_font_size("font_size", "Label", 30)
		label.theme = themeN
		var stylebox = load("res://Assets/UI/portfolio.tres") as StyleBox
		if stylebox:
			label.add_theme_stylebox_override("normal", stylebox)
		revenueBox.add_child(label)
		calc_average()

var SumQual:float = 0
var SumUnits:int = 0
var SumRev:int = 0
var Tot:int = 0

@onready var average_u: Label = $UNITS/AverageU
@onready var average_q: Label = $QUALITY/AverageQ
@onready var average_r: Label = $REVENUE/AverageR
@onready var tot_sales: Label = $"../../TotSales"
@onready var tot_releases: Label = $"../../TotReleases"

func calc_average():
	if Tot > 0:
		var AvgQual:float = round((SumQual / Tot) * 100) / 100
		var AvgUnits:int = SumUnits / Tot
		var AvgRev:int = SumRev / Tot
		average_q.text = " " + str(AvgQual) + " "
		average_r.text = "$" + str(AvgRev) + " "
		average_u.text = " " + str(AvgUnits) + " "
		tot_sales.text = " Total Company Sales: " + str(SumUnits) + " "
		tot_releases.text = " Total Company Releases: " + str(Tot) + " "
		average_q.show()
		average_r.show()
		average_u.show()
	else:
		average_q.hide()
		average_r.hide()
		average_u.hide()

@onready var portfolio: Panel = $"../.."

func _on_pause_2_pressed() -> void:
	portfolio.show()
