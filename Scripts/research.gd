extends Panel

@onready var researchP: Panel = $"."
@onready var level: Label = $Research2/Details/Level
@onready var eta: Label = $Research2/Details/ETA
@onready var cost: Label = $Research2/Details/Cost
@onready var tokens: Label = $Research2/Details/Tokens

var ETA:int
var COST:int

func _on_research_pressed() -> void:
	if Global.research_level != 7:
		researchP.show()
		level.text = "Your level: " + str(Global.research_level)
		tokens.text = "Your tokens: " + str(Global.research_tokens)
		var Cost:String
		match Global.research_level:
			0:
				ETA = 30
				COST = 0
				Cost = "free!"
			1:
				ETA = 40
				COST = 0
				Cost = "free!"
			2:
				ETA = 50
				COST = 0
				Cost = "free!"
			3:
				ETA = 60
				COST = 0
				Cost = "free!"
			4:
				ETA = 70
				COST = 1000000
				Cost = "$1M"
			5:
				ETA = 80
				COST = 10000000
				Cost = "$10M"
			6:
				ETA = 90
				COST = 25000000
				Cost = "$25M"
			7:
				ETA = 0
				COST = 0
				Cost = "?"
		eta.text = "Next level ETA: " + str(ETA / 10) + " Months"
		cost.text = "Next level price: " + Cost

@onready var research: Timer = $"../Timers/Research"
@onready var during_research: Panel = $"../DuringResearch"

func _on_begin_pressed() -> void:
	if Global.research_tokens > 0:
		researchP.hide()
		Global.charge = COST
		Global.in_research = true
		var productivity = (Global.PROD_research / 1.75)
		if productivity < 1:
			productivity = 1
		research.wait_time = float((ETA / 100) / productivity)
		research_prog = 0
		research.start()
		Global.research_tokens -= 1
		refresh_during()
		during_research.show()
		Global.in_menu = false

var research_prog:int = 0

func _on_research_timeout() -> void:
	research_prog += 1
	refresh_during()
	if research_prog == 100:
		research.stop()
		researchFIN()

func _on_exit_pressed() -> void:
	Global.in_menu = false
	researchP.hide()

func researchFIN():
	Global.in_research = false
	Global.research_level += 1
	during_research.hide()
	print("research done!")

@onready var levelinprog: Label = $"../DuringResearch/P/Levelinprog"
@onready var research_progB: ProgressBar = $"../DuringResearch/ResearchProg"

func refresh_during():
	if Global.in_menu == false:
		during_research.show()
	else:
		during_research.hide()
	research_progB.value = research_prog
	levelinprog.text = "Level " + str(Global.research_level + 1)
