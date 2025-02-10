extends HBoxContainer

@onready var nameBox: VBoxContainer = $NAME
@onready var unitsBox: VBoxContainer = %UNITS
@onready var qualityBox: VBoxContainer = $QUALITY
@onready var revenueBox: VBoxContainer = $REVENUE

func _ready() -> void:
	call_style()

var themeN = Theme.new()
var stylebox

func call_style():
	themeN.set_constant("outline_size", "Label", 8)
	var cusFont = load("res://Assets/UI/NewyearCoffee-4nd2D.ttf") as FontFile
	themeN.set_font("font", "Label", cusFont)
	themeN.set_color("font_outline_color", "Label", Color.BLACK)
	themeN.set_font_size("font_size", "Label", 30)
	stylebox = load("res://Assets/UI/portfolio.tres") as StyleBox

func _process(delta: float) -> void:
	add_name()

func add_name():
	if Global.LatestName != "?":
		var label:Label = Label.new()
		label.text = " " + Global.LatestName + " "
		Tot += 1
		Global.LatestName = "?"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		label.theme = themeN
		label.add_theme_stylebox_override("normal", stylebox)
		nameBox.add_child(label)
		add_units()
		add_qual()
		add_rev()

func add_units():
	var labelU:Label = Label.new()
	labelU.text = " " + str(Global.LatestUnits) + " "
	labelU.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	labelU.theme = themeN
	labelU.add_theme_stylebox_override("normal", stylebox)
	unitsBox.add_child(labelU)
	SumUnits += Global.LatestUnits
	calc_average()

func add_qual():
	var label:Label = Label.new()
	SumQual += Global.LatestQual
	label.text = " " + str(round((Global.LatestQual) * 100) / 100) + " "
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.theme = themeN
	label.add_theme_stylebox_override("normal", stylebox)
	qualityBox.add_child(label)
	calc_average()

func add_rev():
	var label:Label = Label.new()
	SumRev += Global.LatestRev
	label.text = "$" + str(Global.LatestRev) + " "
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.theme = themeN
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

@onready var portfolio: Panel = $"../.."

func _on_pause_2_pressed() -> void:
	portfolio.show()
