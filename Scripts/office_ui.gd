extends Control

func _ready() -> void:
	soundfx()
	Engine.time_scale = 1
	if Global.loading_game == true:
		LOADGAME()

@onready var pause: Control = $Pause
@onready var loansB: Button = $Buttons/Loans
@onready var publisherB: Button = $Buttons/Publisher

func _input(event: InputEvent) -> void: # KEYBOARD SHORTCUTS
	if event.is_action_pressed("Return to Main Menu"):
		if Global.autosave > 1:
			SAVEGAME()
			soundfx()
			pause.show()
			Engine.time_scale = 0
			Global.in_pause = true
		else:
			soundfx()
			pause.show()
			Engine.time_scale = 0
			Global.in_pause = true
	if event.is_action_pressed("Develop Menu Open") and Global.gameinprog == false:
		_on_develop_pressed()
	if event.is_action_pressed("Savegame"):
		soundfx()
		SAVEGAME()
	if event.is_action_pressed("Load Game"):
		soundfx()
		LOADGAME()

func _process(delta: float) -> void:
	refresh_inprog_ui()
	refresh_info_ui()
	if Global.pubs != true:
		publisherB.hide()
	if Global.loans != true:
		loansB.hide()
	if Global.resM != true:
		research.hide()
	if Global.conts != true:
		contracts.hide()

# TIMERS:
func newmonth():
	months += 1
	money -= expenses
	if months > 12:
		years += 1
		months = 1
	REFRESH_ALL()

@onready var month_prog: ProgressBar = $Info/T/MonthProg

func monthprog():
	month_prog.value += 1
	if month_prog.value > 9:
		month_prog.value = 0
	refresh_info_ui()

# CONTROL:
var rent:int = 1500
var fans:int = 0
var months:int = 0
var years:int = 0
@export var money:int = 65000
@export var productivity:float
var currentS: int = 0
var highS: int = 0
var lowS: int = 0
var medS:int = 0
var expenses:int

# BUTTON SFX:
@onready var mouse: AudioStreamPlayer2D = $Sounds/Mouse
@onready var dullmouse: AudioStreamPlayer2D = $Sounds/Dullmouse
@onready var filmic: AudioStreamPlayer2D = $Sounds/Filmic
@onready var techno: AudioStreamPlayer2D = $Sounds/Techno
@onready var retro: AudioStreamPlayer2D = $Sounds/Retro

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

# REFRESH COMMANDS:
func REFRESH_ALL():
	refresh_productivity()
	refresh_dev_summary()
	refresh_during_ui()
	refresh_loan()

@onready var develop: Button = $Buttons/Develop
@onready var during: Panel = $During
@onready var saves: Button = $Buttons/Save
@onready var contracts: Button = $Buttons/Contracts
@onready var marketing: Button = $During/Marketing
@onready var research: Button = $Buttons/Research
@onready var pub: Label = $During/Pub

func refresh_inprog_ui():
	if Global.gameinprog == false and Global.in_research == false and Global.in_contract == false:
		develop.show()
		saves.show()
		contracts.show()
		research.show()
		during.hide()
	if Global.gameinprog == true:
		contracts.hide()
		develop.hide()
		research.hide()
		saves.hide()
		during.show()
		if publisher == true:
			marketing.hide()
			pub.show()
		if publisher == false:
			marketing.show()
			pub.hide()
	if Global.in_contract == true or Global.in_research == true:
		contracts.hide()
		research.hide()
		develop.hide()
		saves.hide()

@onready var moneyL: Label = $Info/M/Money
@onready var expensesL: Label = $Info/M/Expenses
@onready var monthsL: RichTextLabel = $Info/T/Months
@onready var fansL: Label = $Info/F/Fans

func refresh_info_ui():
	if Global.charge != 0:
		money -= Global.charge
		Global.charge = 0
	var formatted_value:float
	var suffix:String
	if money >= 1000000000:  # B
		formatted_value = round(money / 1000000000.0 * 10) / 10.0
		suffix = "B+"
	elif money >= 1000000:  # M
		formatted_value = round(money / 1000000.0 * 10) / 10.0
		suffix = "M+"
	elif money >= 1000:  # K
		formatted_value = round(money / 1000.0 * 10) / 10.0
		suffix = "K+"
	else: # UNDER 1K:
		formatted_value = money
		suffix = ""
	moneyL.text = "Bank: $" + str(formatted_value) + suffix
	fansL.text = str(fans) + " Fans"
	monthsL.text = "Year " + str(years) + ", month " + str(months)
	var EXPENSESmod:float = 2 - Global.expM
	expenses = int((payroll + rent + UpgradedRent) * EXPENSESmod)
	var suffixE:String
	var formatted_valueE:float
	if expenses >= 1000000000:  # B
		formatted_valueE = round(expenses / 1000000000.0 * 10) / 10.0
		suffixE = "B+"
	elif expenses >= 1000000:  # M
		formatted_valueE = round(expenses / 1000000.0 * 10) / 10.0
		suffixE = "M+"
	elif expenses >= 1000:  # K
		formatted_valueE = round(expenses / 1000.0 * 10) / 10.0
		suffixE = "K+"
	else: # UNDER 1K:
		formatted_valueE = expenses
		suffixE = ""
	expensesL.text = "Costs: $" + str(formatted_valueE) + suffixE
	if money < 5000 and warning_shown == false:
		warn_bankruptcy()
	if money < -50000:
		BANKRUPT()

@onready var nameL: Label = $During/N/Name
@onready var game_prog: ProgressBar = $During/GameProg
@onready var stage: Label = $During/N/Stage

func refresh_during_ui():
	nameL.text = nameG
	game_prog.value = devperc
	if in_des == true:
		stage.text = "Design Stage"
	if in_gp == true:
		stage.text = "Gameplay Stage"
	if in_pol == true:
		stage.text = "Polish Stage"

var prodBoost:float = 1

func refresh_productivity():
	var BOOST:float = prodBoost
	if Global.research_level > 5:
		BOOST += 0.15
	productivity = (1 + (highS * .325) + (medS * .25) + (lowS * .125)) * (Global.prodM * BOOST)
	Global.PROD_research = productivity
	currentS = highS + medS + lowS

@onready var months_l: Label = $Developing/Header/ETA/MonthsL
@onready var m_share_l: Label = $Developing/Header/Marketshare/MShareL
@onready var price_l: Label = $Developing/Header/Price/PriceL
@onready var summary_l: RichTextLabel = $Developing/Header/Summary/SummaryL

func refresh_dev_summary():
	suggest()
	Mshare()
	if Global.research_level > 3:
		months_l.text = str(devtime / 10) + " Months"
	else:
		months_l.text = "??? Months"
	if Global.research_level > 3:
		var share:int = marketshare * 100
		m_share_l.text = str(share)+ "% Marketshare"
	else:
		m_share_l.text = "???% Marketshare"
	if Global.research_level > 2:
		price_l.text = "$" + str(maxP)
	else:
		price_l.text = "$???"
	devcost = (currentS * 5000) + (SIZE * 10000) + (TECH * 10000) + (DESIGN * 5000)
	summary_l.text = "Develop " + nameG + ", a " + sizeG + " " + genreG + " game with a " + designG + " artstyle?" + " It will cost you $" + str(devcost)

# DEVELOP START:
var nameG:String = "?"
var genreG:String = "?"
var sizeG:String = "?"
var designG:String = "?"
var devperc:int = 0
var GENRE:int = -1
var PLATFORM:int = -1
var SIZE:int = -1
var DESIGN:int = -1
var AUDIENCE:int = -1
var TECH:int = -1
var devtime:float
var marketshare:float
var devcost:int
var popularity:float = 1
var quality:float = 0
var GENREPOP:float

func pre_dev_purge():
	refresh_productivity()
	devperc = 0
	popularity = 1
	quality = 0
	press = 0
	trailer = 0
	demo = 0
	sponsor = 0
	paid = 0
	in_des = false
	in_gp = false
	in_pol = false

@onready var developing: Panel = $Developing

func _on_develop_pressed() -> void:
	soundfx()
	pre_dev_purge()
	developing.show()
	REFRESH_ALL()

func _on_genre_item_selected(index:int) -> void:
	soundfx()
	GENRE = index
	match index:
		0:
			genreG = "Adventure"
			GENREPOP = randf_range(0.8,1)
		1:
			genreG = "FPS"
			GENREPOP = randf_range(0.8,1)
		2:
			genreG = "RPG"
			GENREPOP = randf_range(0.65,85)
		3:
			genreG = "Simulation"
			GENREPOP = randf_range(0.65,85)
		4:
			genreG = "Multiplayer"
			GENREPOP = randf_range(0.8,1)
		5:
			genreG = "Fighter"
			GENREPOP = randf_range(0.65,85)
		6:
			genreG = "Sports"
			GENREPOP = randf_range(0.65,85)
		7:
			genreG = "Action"
			GENREPOP = randf_range(0.8,1)
		8:
			genreG = "Gambling"
			GENREPOP = randf_range(0.4,0.7)
		9:
			genreG = "Platformer"
			GENREPOP = randf_range(0.4,0.7)
		10:
			genreG = "Battle Royale"
			GENREPOP = randf_range(0.8,1)
	Mshare()

func _on_size_item_selected(index:int) -> void:
	soundfx()
	SIZE = (index + 1)
	match index:
		0:
			sizeG = "Small"
		1:
			sizeG = "Medium"
		2:
			sizeG = "Large"
	refresh_dev_summary()

func _on_platform_item_selected(index:int) -> void:
	soundfx()
	PLATFORM = index + 1
	refresh_dev_summary()

func _on_tech_l_item_selected(index:int) -> void:
	soundfx()
	TECH = (index + 1)
	refresh_dev_summary()

func _on_design_item_selected(index:int) -> void:
	soundfx()
	DESIGN = (index + 1)
	match index:
		0:
			designG = "2D"
		1:
			designG = "3D"
		2:
			designG = "Hybrid"
	refresh_dev_summary()

func _on_audience_item_selected(index:int) -> void:
	soundfx()
	AUDIENCE = index + 1
	refresh_dev_summary()

func _on_name_l_text_changed(new_text:String) -> void:
	nameG = new_text
	refresh_dev_summary()

func DEVSTART():
	if AUDIENCE != -1 and DESIGN != -1 and GENRE != -1 and nameG != "?" and SIZE != -1 and TECH != -1 and PLATFORM != -1:
		if money > devcost:
			Global.gameinprog = true
			soundfx()
			money -= devcost
			developing.hide()
			REFRESH_ALL()
			openDESstage()

# CALIBRATION:
func Mshare():
	if PLATFORM ==1 and AUDIENCE ==1:
		marketshare = 0.25 * GENREPOP
	if PLATFORM ==1 and AUDIENCE ==2:
		marketshare = 0.4 * GENREPOP
	if PLATFORM ==1 and AUDIENCE ==3:
		marketshare = 0.55 * GENREPOP
	if PLATFORM ==2 and AUDIENCE ==1:
		marketshare = 0.5 * GENREPOP
	if PLATFORM ==2 and AUDIENCE ==2:
		marketshare = 0.6 * GENREPOP
	if PLATFORM ==2 and AUDIENCE ==3:
		marketshare = 0.3 * GENREPOP
	if PLATFORM ==3 and AUDIENCE ==1:
		marketshare = 0.4 * GENREPOP
	if PLATFORM ==3 and AUDIENCE ==2:
		marketshare = 0.3 * GENREPOP
	if PLATFORM ==3 and AUDIENCE ==3:
		marketshare = 0.1 * GENREPOP
	if PLATFORM ==4 and AUDIENCE ==1:
		marketshare = 0.8 * GENREPOP
	if PLATFORM ==4 and AUDIENCE ==2:
		marketshare = 0.7 * GENREPOP
	if PLATFORM ==4 and AUDIENCE ==3:
		marketshare = 0.45 * GENREPOP
	refresh_dev_summary()

var suggestedP:float
var maxP:float

func suggest():
	var consolefac:int
	var division:float
	match SIZE:
		1:
			division = 3
		2, 3:
			division = 2.4
	match PLATFORM:
		1, 2:
			consolefac = 20
		3:
			consolefac = 30
		4:
			consolefac = 12.5
	var FAC = (SIZE + DESIGN + TECH)
	maxP = (FAC * consolefac * Global.priceM) / division
	suggestedP = (maxP - randi_range(0,6)) * (quality / 90)
	maxP = round(maxP * 100.0) / 100
	suggestedP = round(suggestedP * 100.0) / 100
	if suggestedP < 0:
		suggestedP = 1

# PUBLISHING:
var universe:int
var sales:float
var publisher = false
var revenue:int
var marketmonths:int
var pubMOD:float

func PUBLISH():
	Global.LatestName = nameG
	universe = 1000000
	if publisher == true:
		popularity = 100
	if publisher == false:
		refresh_popularity()
		pubMOD = 1
		pubCut = 1
	var FAC = (SIZE + DESIGN + TECH)
	quality = (randf_range(0.6, 1.1) * stagesFAC) * FAC * 3.75
	if quality > 100:
		quality = 100
	Global.LatestQual = quality
	sales = ((universe * marketshare) * (((popularity * 0.35) + (quality * 0.65)) / 100)) * Global.salesM
	Global.LatestUnits = sales
	suggest()
	if quality < contingency and publisher == true:
		print("contingency in place")
		pubMOD = 0.05
	if contingency < quality and publisher == true:
		pubMOD = pubCut
		print("contingency avoided")
	revenue = (sales * suggestedP) * pubMOD
	Global.LatestRev = revenue
	var newfans = (sales * 0.15 * pubCut) * (quality / 100)
	var oldfans = (fans / 2) * (quality / 100)
	fans = int((oldfans + newfans) * Global.fansM)
	marketmonths = int((SIZE * 3) * (quality / 100)) + 2
	publishedG()
	dev_prog.stop()
	Global.research_tokens += 1

@onready var publish: Panel = $Publish
@onready var shelf: Label = $Publish/CONGRATS/VBoxContainer/Shelf
@onready var marketshare_L: Label = $Publish/CONGRATS/VBoxContainer/Marketshare
@onready var price: Label = $Publish/CONGRATS/VBoxContainer/Price
@onready var wishlists: Label = $Publish/CONGRATS/VBoxContainer/Wishlists
@onready var publisher_l: Label = $Publish/CONGRATS/VBoxContainer/PublisherL
@onready var reviews_l: Label = $Publish/CONGRATS/VBoxContainer/ReviewsL
@onready var review: ProgressBar = $Publish/Reviews/Review
@onready var review_2: ProgressBar = $Publish/Reviews/Review2
@onready var review_3: ProgressBar = $Publish/Reviews/Review3
@onready var review_4: ProgressBar = $Publish/Reviews/Review4
@onready var popularityl: ProgressBar = $Publish/POPULARITYL
@onready var qualityl: ProgressBar = $Publish/Reviews/Label5/QUALITYL
@onready var summaryP: RichTextLabel = $Publish/CONGRATS/Summary

func publishedG(): # UI CHANGES ONLY
	publish.show()
	shelf.text = "Shelf life: " + str(marketmonths) + " months."
	if Global.research_level > 1:
		marketshare_L.text = "Marketshare: " + str(marketshare * 100) + "%"
	else:
		marketshare_L.text = "Marketshare: ???"
	price.text = "Price: $" + str(suggestedP)
	if Global.research_level > 0:
		wishlists.text = "Wishlists: " + str(int(sales / .2))
	else:
		wishlists.text = "Wishlists: ???"
	if publisher == true:
		var pubPerc = 100 - (pubMOD * 100)
		publisher_l.text = "Publisher: " + str(pubPerc) + "% cut"
	if publisher == false:
		publisher_l.text = "Publisher: Self-Published"
	if quality >= 95:
		reviews_l.text = "Reviews: Impeccable"
	elif quality >= 90:
		reviews_l.text = "Reviews: Outstanding"
	elif quality >= 80:
		reviews_l.text = "Reviews: Wonderful"
	elif quality >= 85:
		reviews_l.text = "Reviews: Incredible"
	elif quality >= 70:
		reviews_l.text = "Reviews: Great"
	elif quality >= 50:
		reviews_l.text = "Reviews: Average"
	elif quality >= 40:
		reviews_l.text = "Reviews: Bad"
	elif quality >= 0:
		reviews_l.text = "Reviews: Abhorrent"
	review.value = quality + randi_range(-5,5)
	review_2.value = quality + randi_range(-5,10)
	review_3.value = quality + randi_range(0,5)
	review_4.value = quality + randi_range(-10,0)
	popularityl.value = popularity
	qualityl.value = quality
	summaryP.text = "You have completed " + nameG + "! Read the following analytics to see how well you did and press continue to put it on the market!"

@onready var marketT: Timer = $Timers/Market
var monthsdone:float = 0 # SAVEGAME EXPENSES THING
var expensesRem:int
var moneyRem:int

func onmarket():
	Global.gameinprog = false
	publish.hide()
	monthsdone = 0
	moneyRem = revenue
	REFRESH_ALL()
	marketT.start()
	if Global.autosave != 0 and Global.autosave != 2:
		print("autosaving")
		SAVEGAME()

func monthsales():
	var paycheck:int = ((revenue / marketmonths) / 2) # BIWEEKLY PAY
	money += paycheck
	moneyRem -= paycheck
	monthsdone += 0.5
	expensesRem = expenses * (marketmonths - monthsdone)
	if monthsdone == marketmonths:
		marketT.stop()

# PUBLISHER DEAL:
@onready var publishdeal: Panel = $Publisher

func _on_publisher_pressed() -> void:
	publishdeal.show()

var pubCut:float
var pubdiscount:float = 0
var contingency:float = 0

func _on_publisher_list_item_selected(index:int) -> void:
	soundfx()
	if Global.research_level == 7:
		pubdiscount = 0.1
	else:
		pubdiscount = 0
	match index:
		0:
			pubCut = 0
			publisher = false
			contingency = 0
		1:
			pubCut = 0.35 + pubdiscount
			publisher = true
			contingency = 10
		2:
			pubCut = 0.5 + pubdiscount
			publisher = true
			contingency = 20
		3:
			pubCut = 0.55 + pubdiscount
			publisher = true
			contingency = 30
		4:
			pubCut = 0.6 + pubdiscount
			publisher = true
			contingency = 35
		5:
			pubCut = 0.65 + pubdiscount
			publisher = true
			contingency = 50

@onready var officesPanel: Panel = $Offices
@onready var upgrades: Panel = $Upgrades
@onready var stocks: Panel = $Stocks
@onready var portfolio: Panel = $Portfolio
@onready var researchP: Panel = $Research
@onready var stocksP: Panel = $Stocks
@onready var gsx_400: Panel = $GSX400
@onready var gazdak: Panel = $Gazdak
@onready var ag_nstock: Panel = $AGNstock

func _on_back_p_pressed() -> void:
	soundfx()
	portfolio.hide()
	researchP.hide()
	publishdeal.hide()
	upgrades.hide()
	marketP.hide()
	ag_nstock.hide()
	gsx_400.hide()
	stocksP.hide()
	gazdak.hide()
	staff.hide()
	the_bank.hide()
	officesPanel.hide()
	contractsPanel.hide()
	developing.hide()
	stocks.hide()
	REFRESH_ALL()

# MARKETING:
@onready var marketP: Panel = $Market
@onready var pop_prog: ProgressBar = $Market/PopProg

var press:int = 0
var trailer:int = 0
var demo:int = 0
var sponsor:int = 0
var paid:float = 0

func refresh_popularity():
	soundfx()
	popularity = press + demo + trailer + sponsor + paid
	if popularity == 0:
		popularity = 1
	pop_prog.value = popularity

func _on_marketing_pressed() -> void:
	marketP.show()
	refresh_popularity()

func _on_pr_pressed() -> void:
	if money > 25000 and press == 0:
		money -= 25000
		press = 10
		refresh_popularity()

func _on_t_pressed() -> void:
	if money > 100000 and trailer == 0:
		money -= 100000
		trailer = 10
		refresh_popularity()

func _on_db_2_pressed() -> void:
	if money > 500000 and demo == 0:
		money -= 500000
		demo = 10
		refresh_popularity()

func _on_s_pressed() -> void:
	if money > 1250000 and sponsor == 0:
		money -= 1250000
		sponsor = 10
		refresh_popularity()

func _on_budget_text_submitted(new_text) -> void:
	var budget:int = int(new_text)
	if money > budget and budget < 2000001 and paid < 60.1:
		money -= budget
		paid += (budget * 0.00003)
		if paid > 60.1:
			paid = 60.2
		refresh_popularity()

# STAFF:
@onready var lcount: Label = $Staff/HBoxContainer/YouHave/Lcount
@onready var mcount: Label = $Staff/HBoxContainer/YouHave/Mcount
@onready var hcount: Label = $Staff/HBoxContainer/YouHave/Hcount
@onready var salaries: RichTextLabel = $Staff/Salaries
@onready var amount_left: RichTextLabel = $"Staff/Amount left"
@onready var staff: Panel = $Staff

var payroll:int = 0

func open_staff():
	soundfx()
	refresh_staff_ui()
	staff.show()
	soundfx()

func refresh_staff_ui():
	lcount.text = str(lowS)
	mcount.text = str(medS)
	hcount.text = str(highS)
	salaries.text= "Currently, you are paying a total of $" + str(payroll) + " in salaries."
	amount_left.text = "You have " + str(currentS) + " staff members, meaning your office can hold " + str((Global.maxdesks - currentS)) + " more."

func hireLOW():
	soundfx()
	operation = 1
	tier = 1
	staffControl()

func hireMED():
	soundfx()
	operation = 1
	tier = 2
	staffControl()

func hireHIGH():
	soundfx()
	operation = 1
	tier = 3
	staffControl()

func fireLOW():
	soundfx()
	operation = 2
	tier = 1
	staffControl()

func fireMED():
	soundfx()
	operation = 2
	tier = 2
	staffControl()

func fireHIGH():
	soundfx()
	operation = 2
	tier = 3
	staffControl()

var operation:int # 1 IS HIRE AND 2 IS FIRE
var tier:int

func staffControl():
	var sal = 5000 + (5000 * tier)
	match operation:
		1:
			if money > 25000 and currentS < Global.maxdesks:
				payroll += sal
				money -= 25000
				match tier:
					1:
						lowS += 1
					2:
						medS += 1
					3:
						highS += 1
		2:
			if money > 40000 and currentS > 0:
				payroll -= sal
				money -= 40000
				match tier:
					1:
						lowS -=1
					2:
						medS -= 1
					3:
						highS -= 1
	refresh_productivity()
	refresh_staff_ui()

# THE BANK:
func _on_buying_text_submitted() -> void:
	REFRESH_ALL()

func _on_selling_text_submitted() -> void:
	REFRESH_ALL()

var interestBILL:int = 0
var amount_taken:int = 0
var in_loan = false
var loan_id:int = 0
var MonthLoan:int = 0

@onready var the_bank: Panel = $TheBank
@onready var in_loan_menu: Panel = $TheBank/InLoanMenu
@onready var out_loan: Control = $TheBank/OutLoan
@onready var loanTIMER: Timer = $Timers/LOAN

func _on_take_pressed() -> void: # SMALL
	soundfx()
	out_loan.hide()
	in_loan_menu.show()
	interestBILL += 27000
	money += 1000000
	in_loan = true
	amount_taken = 1600000
	loan_id = 1
	MonthLoan = 0
	refresh_loan()
	loanTIMER.start()

func _on_take_m_pressed() -> void: # MEDIUM
	soundfx()
	out_loan.hide()
	in_loan_menu.show()
	interestBILL += 93750
	money += 5000000
	in_loan = true
	amount_taken = 9000000
	loan_id = 2
	MonthLoan = 0
	refresh_loan()
	loanTIMER.start()

func _on_take_l_pressed() -> void: # LARGE
	soundfx()
	out_loan.hide()
	in_loan_menu.show()
	interestBILL += 128500
	money += 10000000
	in_loan = true
	amount_taken = 18500000
	loan_id = 3
	MonthLoan = 0
	refresh_loan()
	loanTIMER.start()

@onready var rate: Label = $TheBank/InLoanMenu/Detailsposttake/Rate
@onready var term: Label = $TheBank/InLoanMenu/Detailsposttake/Term
@onready var amt_rem: Label = $TheBank/InLoanMenu/Detailsposttake/AmtRem
@onready var bill: Label = $TheBank/InLoanMenu/Detailsposttake/Bill
@onready var early: Label = $TheBank/InLoanMenu/Detailsposttake/Early

func loanTIMERend():
	money -= interestBILL
	MonthLoan += 1
	amount_taken -= interestBILL
	refresh_loan()

func refresh_loan():
	if amount_taken <= 0:
		loan_paid()
	else:
		amt_rem.text = "You owe: $" + str(amount_taken)
		early.text = "Save 15% by paying early: $" + str(int(amount_taken * .85))
		match loan_id:
			1:
				rate.text = "60% interest small loan"
				term.text = "Time remaining: " + str((60 - MonthLoan)) + " months"
				bill.text = "Monthy payment: $27,000"
			2:
				rate.text = "75% interest medium loan"
				term.text = "Time remaining: " + str((96 - MonthLoan)) + " months"
				bill.text = "Monthy payment: $93,750"
			3:
				rate.text = "85% interest large loan"
				term.text = "Time remaining: " + str((144 - MonthLoan)) + " months"
				bill.text = "Monthy payment: $128,500"

func loan_paid():
	in_loan = false
	interestBILL = 0
	amount_taken = 0
	loan_id = 0
	out_loan.show()
	in_loan_menu.hide()
	loanTIMER.stop()

func _on_loans_pressed() -> void:
	the_bank.show()
	refresh_loan()

func _on_pay_pressed() -> void:
	if money > int(amount_taken * .85):
		soundfx()
		money -= int(amount_taken * .85)
		loan_paid()

# REAL ESTATE:
@onready var starter: Button = $Offices/Table/Move/Starter
@onready var amareur: Button = $Offices/Table/Move/Amareur
@onready var small: Button = $Offices/Table/Move/Small
@onready var medium: Button = $Offices/Table/Move/Medium
@onready var large: Button = $Offices/Table/Move/Large
@onready var skyscraper: Button = $Offices/Table/Move/Skyscraper

func refresh_officeUI():
	starter.text = " Sign Lease "
	amareur.text = " Sign Lease "
	small.text = " Sign Lease "
	medium.text = " Sign Lease "
	large.text = " Sign Lease "
	skyscraper.text = " Sign Lease "
	if Global.office_id == 0:
		starter.text = " SIGNED "
	if Global.office_id == 1:
		amareur.text = " SIGNED "
	if Global.office_id == 2:
		small.text = " SIGNED "
	if Global.office_id == 3:
		medium.text = " SIGNED "
	if Global.office_id == 4:
		large.text = " SIGNED "
	if Global.office_id == 5:
		skyscraper.text = " SIGNED "

func _on_starter_pressed() -> void:
	soundfx()
	tempOffID = 0
	move()

func _on_amareur_pressed() -> void:
	soundfx()
	tempOffID = 1
	move()

func _on_small_pressed() -> void:
	soundfx()
	tempOffID = 2
	move()

func _on_medium_pressed() -> void:
	soundfx()
	tempOffID = 3
	move()

func _on_large_pressed() -> void:
	soundfx()
	tempOffID = 4
	move()

func _on_skyscraper_pressed() -> void:
	soundfx()
	tempOffID = 5
	move()

var limit:int = 5
var tempOffID:int = 0
var propRENT:int = 1500

func move():
	match tempOffID:
		0:
			limit = 5
			propRENT = 1500
		1:
			limit = 9
			propRENT = 10000
		2:
			limit = 14
			propRENT = 30000
		3:
			limit = 24
			propRENT = 75000
		4:
			limit = 39
			propRENT = 125000
		5:
			limit = 59
			propRENT = 200000
	if money > 50000 + (currentS * 5000) and currentS <= limit:
		money -= 50000 + (currentS * 5000)
		Global.maxdesks = limit
		Global.office_id = tempOffID
		rent = propRENT
		REFRESH_ALL()

func RealEstateButton():
	refresh_officeUI()
	officesPanel.show()
	soundfx()

# BANKRUPTCY:
@onready var bankruptcy_warning: Panel = $BankruptcyWarning

var warning_shown = false

func warn_bankruptcy():
	bankruptcy_warning.show()
	warning_shown = true
	soundfx()

func exit_warning():
	soundfx()
	bankruptcy_warning.hide()
	REFRESH_ALL()

@onready var bankrupt: Control = $Bankrupt

func BANKRUPT():
	soundfx()
	Global.in_contract = false
	Global.in_research = false
	Global.gameinprog = false
	Engine.time_scale = 0
	bankrupt.show()

# CONTRACT WORK:
@onready var contractsPanel: Panel = $Contracts
@onready var accept_pj: Button = $Contracts/Contract1/AcceptPJ
@onready var accept_agn: Button = $Contracts/Contract2/AcceptAGN
@onready var accept_c: Button = $Contracts/Contract3/AcceptC
@onready var accept_b: Button = $Contracts/Contract4/AcceptB
@onready var contract_time: Timer = $Contracts/ContractTime

var contract_id:int
var payout:int
var time_done:int
var contract_prod:float = 1

func _on_contracts_pressed() -> void:
	soundfx()
	contractsPanel.show()
	progress_c.value = 0
	contract_prod = productivity / 1.75
	if contract_prod < 1:
		contract_prod = 1

func _on_accept_pj_pressed() -> void:
	soundfx()
	if highS > 0:
		Global.in_contract = true
		contractsPanel.hide()
		REFRESH_ALL()
		contract_id = 0
		contract_time.wait_time = float(0.8 / contract_prod)
		time_done = 0
		payout = 500000
		contract_time.start()
		during_contract.show()
		during_contract_ui()

func _on_accept_agn_pressed() -> void:
	soundfx()
	if currentS > 0:
		Global.in_contract = true
		contractsPanel.hide()
		REFRESH_ALL()
		contract_id = 1
		contract_time.wait_time = float(0.6 / contract_prod)
		time_done = 0
		payout = 250000
		contract_time.start()
		during_contract.show()
		during_contract_ui()

func _on_accept_c_pressed() -> void:
	soundfx()
	if fans > 25000:
		Global.in_contract = true
		contractsPanel.hide()
		REFRESH_ALL()
		contract_id = 2
		contract_time.wait_time = float(0.2 / contract_prod)
		time_done = 0
		payout = 100000
		contract_time.start()
		during_contract.show()
		during_contract_ui()

func _on_accept_b_pressed() -> void:
	soundfx()
	Global.in_contract = true
	contractsPanel.hide()
	REFRESH_ALL()
	contract_id = 3
	contract_time.wait_time = float(1.2 / contract_prod)
	time_done = 0
	payout = 800000
	contract_time.start()
	during_contract.show()
	during_contract_ui()

@onready var company: Label = $DuringContract/Panel/Company
@onready var progress_c: ProgressBar = $DuringContract/ProgressC
@onready var during_contract: Panel = $DuringContract

func during_contract_ui():
	match contract_id:
		0:
			company.text = "Jones Inc."
		1:
			company.text = "AGN"
		2:
			company.text = "Charity"
		3:
			company.text = "Blaze"

func _on_contract_time_timeout() -> void:
	time_done += 1
	progress_c.value = time_done
	if time_done >= 100:
		contract_time.stop()
		Global.in_contract = false
		money += payout
		during_contract.hide()

# SAVING AND LOADING:

func SAVEGAME():
	print("saving")
	var file
	match Global.slot:
		1:
			file = FileAccess.open("res://savegame1.dat", FileAccess.WRITE)
		2:
			file = FileAccess.open("res://savegame2.dat", FileAccess.WRITE)
		3:
			file = FileAccess.open("res://savegame3.dat", FileAccess.WRITE)
		4:
			file = FileAccess.open("res://savegame4.dat", FileAccess.WRITE)
		5:
			file = FileAccess.open("res://savegame5.dat", FileAccess.WRITE)
	file.store_var(money)
	file.store_var(months)
	file.store_var(years)
	file.store_var(rent) # DONT NEED TO STORE EXPENSES BECAUSE OF THESE TWO
	file.store_var(payroll)
	file.store_var(Global.research_level)
	file.store_var(Global.research_tokens)
	file.store_var(Global.office_id)
	file.store_var(Global.maxdesks)
	file.store_var(lowS) # DONT NEED TO STORE CURRENTS BECAUSE OF THESE THREE
	file.store_var(medS)
	file.store_var(highS)
	file.store_var(interestBILL)
	file.store_var(amount_taken)
	file.store_var(loan_id)
	file.store_var(in_loan)
	file.store_var(MonthLoan)
	file.store_var(expensesRem)
	file.store_var($Info/T/MonthProg.value)
	file.store_var(moneyRem)
	file.store_var(Global.loans)
	file.store_var(Global.pubs)
	file.store_var(Global.conts)
	file.store_var(Global.resM)
	file.store_var(Global.prodM)
	file.store_var(Global.priceM)
	file.store_var(Global.salesM)
	file.store_var(Global.fansM)
	file.store_var(Global.expM)
	file.store_var(Global.CopiesSold)
	file.store_var(Global.Sunits)
	file.close()
	print("saved file: " + str(Global.slot))

func LOADGAME():
	print("loading")
	var file
	match Global.slot:
		1:
			file = FileAccess.open("res://savegame1.dat", FileAccess.READ)
		2:
			file = FileAccess.open("res://savegame2.dat", FileAccess.READ)
		3:
			file = FileAccess.open("res://savegame3.dat", FileAccess.READ)
		4:
			file = FileAccess.open("res://savegame4.dat", FileAccess.READ)
		5:
			file = FileAccess.open("res://savegame5.dat", FileAccess.READ)
	money = file.get_var(money)
	months = file.get_var(months)
	years = file.get_var(years)
	rent = file.get_var(rent) # DONT NEED TO STORE EXPENSES BECAUSE OF THESE TWO
	payroll = file.get_var(payroll)
	Global.research_level = file.get_var(Global.research_level)
	Global.research_tokens = file.get_var(Global.research_tokens)
	Global.office_id = file.get_var(Global.office_id)
	Global.maxdesks = file.get_var(Global.maxdesks)
	lowS = file.get_var(lowS) # DONT NEED TO STORE CURRENTS BECAUSE OF THESE THREE
	medS = file.get_var(medS)
	highS = file.get_var(highS)
	interestBILL = file.get_var(interestBILL)
	amount_taken = file.get_var(amount_taken)
	loan_id = file.get_var(loan_id)
	in_loan = file.get_var(in_loan)
	MonthLoan = file.get_var(MonthLoan)
	expensesRem = file.get_var(expensesRem)
	$Info/T/MonthProg.value = file.get_var($Info/T/MonthProg.value)
	moneyRem = file.get_var(moneyRem)
	Global.loans = file.get_var(Global.loans)
	Global.pubs = file.get_var(Global.pubs)
	Global.conts = file.get_var(Global.conts)
	Global.resM = file.get_var(Global.resM)
	Global.prodM = file.get_var(Global.prodM)
	Global.priceM = file.get_var(Global.priceM)
	Global.salesM = file.get_var(Global.salesM)
	Global.fansM = file.get_var(Global.fansM)
	Global.expM = file.get_var(Global.expM)
	Global.CopiesSold = file.get_var(Global.CopiesSold)
	Global.LogoID = file.get_var(Global.Sunits)
	file.close()
	if in_loan != false:
		refresh_loan()
		loanTIMER.start()
	if moneyRem != 0:
		money += moneyRem - expensesRem
		var EXPENSESmod:float = 2 - Global.expM
		expenses = int((payroll + rent + UpgradedRent) * EXPENSESmod)
		months += int(expensesRem / expenses)
	REFRESH_ALL()
	print("loaded save file: " + str(Global.slot))

# AUTOSAVE ON RETURN TO MAIN MENU:
@onready var autosave_wait: Timer = $Timers/AutosaveWait

func _on_autosave_wait_timeout() -> void:
	soundfx()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

# DEVELOPMENT STAGES (FEATURES):
@onready var _2dDES: VBoxContainer = $"DevstageOne/HBoxContainer/2D"
@onready var _3dDES: VBoxContainer = $"DevstageOne/HBoxContainer/3D"
@onready var hybridDES: VBoxContainer = $DevstageOne/HBoxContainer/Hybrid

var dphasemod:float # DESIGN TOTAL
var dstageog:float # DESIGN TOTAL - ART STYLE
var amtcheckedtwoD:int = 0 # DESIGN FEATURES
var amtcheckedthreeD:int = 0 # DESIGN FEATURES
var amtcheckedHYBRID:int = 0 # DESIGN FEATURES

var gstagemod:float # GP TOTAL
var amtcheckedGSTAGE:int = 0 # GP FEATURES
var gstageog:float # GP TOTAL - SIZE

var pstagemod:float # POL TOTAL
var amtcheckedPOLISH:int = 0 # POL FEATURES
var pstageog:float # POL TOTAL - SIZE

func refreshDstage(): # DESIGN
	_2dDES.hide()
	_3dDES.hide()
	hybridDES.hide()
	match DESIGN:
		1:
			_2dDES.show()
		2:
			_3dDES.show()
		3:
			hybridDES.show()

func twoDchecker(toggled_on: bool) -> void: # DESIGN 2D
	soundfx()
	if toggled_on == true:
		amtcheckedtwoD += 1
	if toggled_on != true:
		amtcheckedtwoD -= 1
	refresh_TWOdphase()

func refresh_TWOdphase(): # DESIGN 2D
	match amtcheckedtwoD:
		1:
			dphasemod = 0.15
		2:
			dphasemod = 0.5
		3:
			dphasemod = 0.75
		4:
			dphasemod = 1
		5:
			dphasemod = 1.2
		6:
			dphasemod = 1.4
	dstageog = dphasemod

func threeDchecker(toggled_on: bool) -> void: # DESIGN 3D
	soundfx()
	if toggled_on == true:
		amtcheckedthreeD += 1
	if toggled_on != true:
		amtcheckedthreeD -= 1
	refresh_THREEdphase()

func refresh_THREEdphase(): # DESIGN 3D
	match amtcheckedthreeD:
		1:
			dphasemod = 0.15
		2:
			dphasemod = 0.5
		3:
			dphasemod = 0.75
		4:
			dphasemod = 1
		5:
			dphasemod = 1.2
		6:
			dphasemod = 1.4
	dstageog = dphasemod
	dphasemod += 1

func HYchecker(toggled_on: bool) -> void: # DESIGN HYBRID
	soundfx()
	if toggled_on == true:
		amtcheckedHYBRID += 1
	if toggled_on != true:
		amtcheckedHYBRID -= 1
	refresh_HYdphase()

func refresh_HYdphase(): # DESIGN HYBRID
	match amtcheckedHYBRID:
		1:
			dphasemod = 0.15
		2:
			dphasemod = 0.5
		3:
			dphasemod = 0.75
		4:
			dphasemod = 1
		5:
			dphasemod = 1.2
		6:
			dphasemod = 1.4
	dstageog = dphasemod
	dphasemod += 2

func GPchecker(toggled_on: bool) -> void: # GAMEPLAY
	
	if toggled_on == true:
		amtcheckedGSTAGE += 1
	if toggled_on != true:
		amtcheckedGSTAGE -= 1
	refresh_GPphase()

func refresh_GPphase(): # GAMEPLAY
	soundfx()
	match amtcheckedGSTAGE:
		0:
			print("AMTCHECKED for g stage is zero")
		1:
			gstagemod = 0.2
			gstageog = 0.2
		2:
			gstagemod = 0.4
			gstageog = 0.4
		3:
			gstagemod = 0.6
			gstageog = 0.6
		4:
			gstagemod = 0.8
			gstageog = 0.8
		5:
			gstagemod = 1
			gstageog = 1
		6:
			gstagemod = 1.2
			gstageog = 1.2
		7:
			gstagemod = 1.4
			gstageog = 1.4
	gstagemod += (SIZE - 1)

func POLchecker(toggled_on: bool) -> void: # POLISH
	if toggled_on == true:
		amtcheckedPOLISH += 1
	if toggled_on != true:
		amtcheckedPOLISH -= 1
	refresh_POLphase()

func refresh_POLphase(): # POLISH
	soundfx()
	match amtcheckedPOLISH:
		0:
			print("AMTCHECKED for POL stage is zero")
		1:
			pstagemod = 0.15
			pstageog = 0.15
		2:
			pstagemod = 0.5
			pstageog = 0.5
		3:
			pstagemod = 0.75
			pstageog = 0.75
		4:
			pstagemod = 1
			pstageog = 1
		5:
			pstagemod = 1.2
			pstageog = 1.2
		6:
			pstagemod = 1.4
			pstageog = 1.4
	pstagemod += (SIZE - 1)

# DEV CYCLE (TIME MANAGEMENT):
@onready var dev_prog: Timer = $Timers/DevProg
@onready var devstage_two: Panel = $DevstageTwo
@onready var devstage_three: Panel = $DevstageThree
@onready var devstage_one: Panel = $DevstageOne

var in_des = false
var in_gp = false
var in_pol = false

func openDESstage():
	refreshDstage()
	devstage_one.show()
	in_des = true

func destime():
	soundfx()
	refresh_productivity()
	dev_prog.wait_time = float((0.9 * dphasemod) / productivity)
	print(str(float((0.4 * dphasemod) / productivity)) + " DESIGN timer")
	dev_prog.start()
	devstage_one.hide()
	devperc = 0

func openGPstage():
	dev_prog.stop()
	in_des = false
	in_gp = true
	devstage_two.show()
	devperc = 0
	print(str(dstageog) + "dstage")

func GPtime():
	soundfx()
	refresh_productivity()
	dev_prog.wait_time = float((1 * gstagemod) / productivity)
	print(str(float((0.6 * gstagemod) / productivity)) + " GP timer")
	dev_prog.start()
	devstage_two.hide()

func openPOLstage():
	dev_prog.stop()
	in_gp = false
	in_pol = true
	devstage_three.show()
	devperc = 0
	print(str(gstageog) + "gstage")

func POLtime():
	soundfx()
	refresh_productivity()
	dev_prog.wait_time = float((0.8 * pstagemod) / productivity)
	print(str(float((0.4 * pstagemod) / productivity)) + " POLISH timer")
	dev_prog.start()
	devstage_three.hide()

var stagesFAC:float = 0

func GAMEDONE():
	stagesFAC = gstageog + pstageog + dstageog
	print(str(pstageog) + "pstage")
	print(str(stagesFAC) + "STAGES FACTOR")
	in_pol = false
	dev_prog.stop()
	PUBLISH()

func _on_dev_prog_timeout() -> void:
	devperc += 1
	refresh_during_ui()
	if devperc == 100 and in_des == true:
		openGPstage()
	if devperc == 100 and in_gp == true:
		openPOLstage()
	if devperc == 100 and in_pol == true:
		GAMEDONE()

# OFFICE UPGRADES:
@onready var Up1: Label = $Upgrades/VBoxContainer/Label5
@onready var Up2: Label = $Upgrades/VBoxContainer/Label
@onready var Up3: Label = $Upgrades/VBoxContainer/Label2
@onready var Up4: Label = $Upgrades/VBoxContainer/Label3
@onready var Up5: Label = $Upgrades/VBoxContainer/Label4
@onready var Up6: Label = $Upgrades/VBoxContainer/Label6
@onready var Up7: Label = $Upgrades/VBoxContainer/Label7

var UpgradedRent:int = 0

func _on_upgrades_pressed() -> void:
	soundfx()
	upgrades.show()
	officesPanel.hide()

func _on_wifi_pressed() -> void:
	propUp = 1
	upgrade()

func _on_ac_pressed() -> void:
	propUp = 2
	upgrade()

func _on_books_pressed() -> void:
	propUp = 3
	upgrade()

func _on_cafeteria_pressed() -> void:
	propUp = 4
	upgrade()

func _on_windows_pressed() -> void:
	propUp = 5
	upgrade()

func _on_servers_pressed() -> void:
	propUp = 6
	upgrade()

func _on_cars_pressed() -> void:
	propUp = 7
	upgrade()

var propUp:int = 1

func upgrade(): # UPGRADES MANAGER
	soundfx()
	var price:int
	match propUp:
		1, 2:
			price = 50000
		3, 4:
			price = 125000
		5, 6:
			price = 300000
		7:
			price = 500000
	if money > price:
		money -= price
		prodBoost += 0.25
		UpgradedRent += 25000
		match propUp:
			1:
				Up1.hide()
			2:
				Up2.hide()
			3:
				Up3.hide()
			4:
				Up4.hide()
			5:
				Up5.hide()
			6:
				Up6.hide()
			7:
				Up7.hide()

# CONVENTION:
@onready var invitation: Panel = $Invitation
@onready var convention_inv: Timer = $Timers/ConventionInv

func _on_convention_inv_timeout() -> void:
	if money > 250000 and fans > 5000:
		soundfx()
		invitation.show()
	else:
		pass

func _on_con_d_pressed() -> void:
	soundfx()
	invitation.hide()

@onready var real_conv: Timer = $Timers/RealConv

func _on_con_a_pressed() -> void:
	money -= 250000
	real_conv.start()
	convention_inv.stop()
	soundfx()
	invitation.hide()

@onready var result: RichTextLabel = $Convention/Result
@onready var convention: Panel = $Convention

func _on_real_conv_timeout() -> void:
	var gain:int = randi_range(50000,100000)
	fans += gain
	result.text = "You blew up at the convention and gained " + str(gain) + " fans! everyone loved your company's showcase! We hope you come again next year!"
	convention.show()

func _on_close_conv_pressed() -> void:
	convention.hide()
	convention_inv.start()
	real_conv.stop()
	soundfx()

# STOCK MARKET:

func _on_a_pressed() -> void:
	soundfx()
	ag_nstock.show()
	stocksP.hide()

func _on_g_pressed() -> void:
	soundfx()
	gazdak.show()
	stocksP.hide()

func _on_gsx_pressed() -> void:
	soundfx()
	gsx_400.show()
	stocksP.hide()

func _on_stocks_pressed() -> void:
	soundfx()
	stocksP.show()
