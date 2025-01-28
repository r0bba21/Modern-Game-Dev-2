extends Control
func _ready() -> void:
	soundfx()
	difficulty_select()
	Engine.time_scale = 1

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
var gameinprog = false
var fans:int = 0
var months:int = 0
var years:int = 0
var money:int = 65000
var productivity:float
var currentS: int = 0
var highS: int = 0
var lowS: int = 0
var medS:int = 0
var expenses:int

# DIFFICULTY MULTIPLIERS:
var prodM:float
var priceM:float
var salesM:float

func difficulty_select():
	match Global.difficulty:
		1: # EASY
			prodM = 1.6
			salesM = 1.3
			priceM = 1.2
		2: # NORMAL
			prodM = 1
			salesM = 1
			priceM = 1
		3: # HARD
			prodM = .7
			salesM = .65
			priceM = .6
		4: # IMPOSSIBLE
			prodM = .45
			salesM = .4
			priceM = .4

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
	refresh_inprog_ui()
	refresh_info_ui()
	refresh_productivity()
	refresh_dev_summary()
	refresh_during_ui()
	refresh_loan()

@onready var develop: Button = $Buttons/Develop
@onready var during: Panel = $During
@onready var saves: VBoxContainer = $Buttons/Mini/Saves
@onready var contracts: Button = $Buttons/Contracts
@onready var marketing: Button = $During/Marketing
@onready var research: Button = $Buttons/Research

func refresh_inprog_ui():
	if gameinprog == false and Global.in_research == false and Global.in_contract == false:
		develop.show()
		saves.show()
		contracts.show()
		research.show()
		during.hide()
	if gameinprog == true:
		contracts.hide()
		develop.hide()
		research.hide()
		saves.hide()
		if Global.in_menu == false:
			during.show()
			if publisher == true:
				marketing.hide()
			else:
				print("failure")
				marketing.show()
		else:
			during.hide()

@onready var moneyL: Label = $Info/M/Money
@onready var expensesL: Label = $Info/M/Expenses
@onready var monthsL: RichTextLabel = $Info/T/Months
@onready var fansL: Label = $Info/F/Fans

func refresh_info_ui():
	if Global.charge > 0:
		money -= Global.charge
		Global.charge = 0
	if money < 0:
		moneyL.text = "Bank: $" + str(money)
	if money < 1000000 and money > 0:
		var moneyT = int(money / 100)
		moneyL.text = "Bank: $" + str(moneyT / 10) + "K+"
	if money < 1000000000 and money > 1000000:
		var moneyT = int(money / 100000)
		moneyL.text = "Bank: $" + str(moneyT / 10) + "M+"
	if money > 1000000000:
		var moneyT = int(money / 100000000)
		moneyL.text = "Bank: $" + str(moneyT / 10) + "B+"
	fansL.text = str(fans) + " Fans"
	monthsL.text = "Year " + str(years) + ", month " + str(months)
	expenses = payroll + rent + interestBILL
	if expenses < 1000000:
		var expenseT:float = expenses / 100
		expensesL.text = "Costs: $" + str(expenseT / 10) + "K+"
	if expenses < 1000000000 and expenses > 1000000:
		var expenseT = int(expenses / 1000000)
		moneyL.text = "Costs: $" + str(expenseT / 10) + "M+"
	MonthLoan += 1
	amount_taken -= interestBILL

@onready var nameL: Label = $During/N/Name
@onready var game_prog: ProgressBar = $During/GameProg

func refresh_during_ui():
	nameL.text = nameG
	game_prog.value = devperc

func refresh_productivity():
	var prodBoost:float
	if Global.research_level > 5:
		prodBoost = 1.15
	else:
		prodBoost = 1
	productivity = (1 + (highS * .25) + (medS * .12) + (lowS * .075)) * (prodM * prodBoost)
	currentS = highS + medS + lowS
	if gameinprog == true:
		refreshdevtimer()

@onready var months_l: Label = $Developing/Header/ETA/MonthsL
@onready var m_share_l: Label = $Developing/Header/Marketshare/MShareL
@onready var price_l: Label = $Developing/Header/Price/PriceL
@onready var summary_l: RichTextLabel = $Developing/Header/Summary/SummaryL

func refresh_dev_summary():
	suggest()
	Mshare()
	dev_time()
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

@onready var developing: Panel = $Developing

func _on_develop_pressed() -> void:
	soundfx()
	pre_dev_purge()
	developing.show()
	Global.in_menu = true
	REFRESH_ALL()

func _on_genre_item_selected(index:int) -> void:
	soundfx()
	GENRE = index
	match index:
		0:
			genreG = "Adventure"
		1:
			genreG = "FPS"
		2:
			genreG = "RPG"
		3:
			genreG = "Simulation"
		4:
			genreG = "Multiplayer"
		5:
			genreG = "Fighter"
		6:
			genreG = "Sports"
		7:
			genreG = "Action"
	refresh_dev_summary()

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
			gameinprog = true
			soundfx()
			money -= devcost
			Global.in_menu = false
			developing.hide()
			REFRESH_ALL()
			dev_prog.start()

# CALIBRATION:
func Mshare():
	if PLATFORM ==1 and AUDIENCE ==1:
		marketshare = 0.25
	if PLATFORM ==1 and AUDIENCE ==2:
		marketshare = 0.4
	if PLATFORM ==1 and AUDIENCE ==3:
		marketshare = 0.55
	if PLATFORM ==2 and AUDIENCE ==1:
		marketshare = 0.5
	if PLATFORM ==2 and AUDIENCE ==2:
		marketshare = 0.6
	if PLATFORM ==2 and AUDIENCE ==3:
		marketshare = 0.3
	if PLATFORM ==3 and AUDIENCE ==1:
		marketshare = 0.4
	if PLATFORM ==3 and AUDIENCE ==2:
		marketshare = 0.3
	if PLATFORM ==3 and AUDIENCE ==3:
		marketshare = 0.1
	if PLATFORM ==4 and AUDIENCE ==1:
		marketshare = 0.8
	if PLATFORM ==4 and AUDIENCE ==2:
		marketshare = 0.7
	if PLATFORM ==4 and AUDIENCE ==3:
		marketshare = 0.45

var suggestedP:float
var maxP:float

func suggest():
	var consolefac:int
	match PLATFORM:
		1:
			consolefac = 20
		2:
			consolefac = 20
		3:
			consolefac = 30
		4:
			consolefac = 12.5
	maxP = ((consolefac * SIZE)+(TECH * 4)+(DESIGN * 4)) * priceM
	suggestedP = (((consolefac * SIZE)+(TECH * 4)+(DESIGN*4))* (quality / 100) - randi_range(0,6)) * priceM
	if suggestedP < 0:
		suggestedP = 1

@onready var dev_prog: Timer = $Timers/DevProg
var fac

func dev_time():
	fac = ((SIZE + TECH + DESIGN) * 100)
	devtime = fac / productivity
	dev_prog.wait_time = float(devtime / 100)

func refreshdevtimer():
	devtime = (fac / productivity)

func _on_dev_prog_timeout() -> void:
	devperc += 1
	refresh_during_ui()

# PUBLISHING:
var universe:int
var sales:float
var publisher = false
var revenue:int
var marketmonths:int

func PUBLISH():
	if publisher == true:
		universe = 1000000 * pubBoost
		popularity = 100
	else:
		universe = 1000000
		refresh_popularity()
	quality = ((devperc - randi_range(0,15)) * 0.7) + ((SIZE + DESIGN + TECH) * randi_range(1,3))
	if quality > 100:
		quality = 100
	sales = ((universe * marketshare) * (((popularity * 0.4) + (quality * 0.7)) / 100)) * salesM
	suggest()
	var  pubMOD:float
	if quality < contingency:
		pubMOD = 0.05
	if contingency < quality:
		pubMOD = pubCut
	revenue = (sales * suggestedP) * pubMOD
	var newfans = (sales * 0.15 * pubCut) * (quality / 100)
	var oldfans = (fans / 2) * (quality / 100)
	fans = int(oldfans + newfans)
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

func publishedG():
	publish.show()
	Global.in_menu = true
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
		var pubMOD:float
		if quality < contingency:
			pubMOD = 0.05
		if contingency > quality:
			pubMOD = pubCut
		var pubPerc = 100 - (pubMOD * 100)
		publisher_l.text = "Publisher: " + str(pubPerc) + "% cut"
	if publisher == false:
		publisher_l.text = "Publisher: Self-Published"
	if quality > 95:
		reviews_l.text = "Reviews: Impeccable"
	elif quality > 90:
		reviews_l.text = "Reviews: Outstanding"
	elif quality > 80:
		reviews_l.text = "Reviews: Wonderful"
	elif quality > 85:
		reviews_l.text = "Reviews: Incredible"
	elif quality > 70:
		reviews_l.text = "Reviews: Great"
	elif quality > 50:
		reviews_l.text = "Reviews: Average"
	elif quality > 40:
		reviews_l.text = "Reviews: Bad"
	elif quality > 0:
		reviews_l.text = "Reviews: Abhorrent"
	review.value = quality + randi_range(-5,5)
	review_2.value = quality + randi_range(-5,10)
	review_3.value = quality + randi_range(0,5)
	review_4.value = quality + randi_range(-10,0)
	popularityl.value = popularity
	qualityl.value = quality
	summaryP.text = "You have completed " + nameG + "! Read the following analytics to see how well you did and press continue to put it on the market!"

@onready var marketT: Timer = $Timers/Market
var monthsdone = 0
var expensesRem

func onmarket():
	gameinprog = false
	Global.in_menu = false
	publish.hide()
	monthsdone = 0
	REFRESH_ALL()
	marketT.start()

func monthsales():
	money += (revenue / marketmonths)
	expensesRem = expenses * (marketmonths - monthsdone)
	monthsdone += 1
	if monthsdone == marketmonths:
		marketT.stop()

# PUBLISHER DEAL:
@onready var publishdeal: Panel = $Publisher

func _on_publisher_pressed() -> void:
	publishdeal.show()
	Global.in_menu = true

var pub_id:int = 0
var pubCut:float
var pubBoost:float
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
			pubBoost = 1
			publisher = false
			contingency = 0
			pub_id = 0
		1:
			pubCut = 0.1 + pubdiscount
			pubBoost = 1.3
			publisher = true
			contingency = 90
			pub_id = 1
		2:
			pubCut = 0.15 + pubdiscount
			pubBoost = 1.25
			publisher = true
			contingency = 85
			pub_id = 2
		3:
			pubCut = 0.3 + pubdiscount
			pubBoost = 1.2
			publisher = true
			contingency = 75
			pub_id = 3
		4:
			pubCut = 0.55 + pubdiscount
			pubBoost = 1.1
			publisher = true
			contingency = 60
			pub_id = 4
		5:
			pubCut = 0.7 + pubdiscount
			pubBoost = 1.05
			publisher = true
			contingency = 60
			pub_id = 5

func _on_back_p_pressed() -> void:
	Global.in_menu = false
	publishdeal.hide()
	marketP.hide()
	staff.hide()
	the_bank.hide()
	REFRESH_ALL()

# MARKETING:
@onready var marketP: Panel = $Market
@onready var pop_prog: ProgressBar = $Market/Price6/PopProg

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
	Global.in_menu = true
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

func _on_budget_text_submitted(new_text:float) -> void:
	if money > new_text and new_text < 2500001 and paid < 60.1:
		paid += (new_text * 0.000024)
		if paid < 60.1:
			paid = 60.2
		refresh_popularity()

# STAFF:
@onready var lcount: Label = $Staff/HBoxContainer/Tier3/Lcount
@onready var mcount: Label = $Staff/HBoxContainer/Tier3/Mcount
@onready var hcount: Label = $Staff/HBoxContainer/Tier3/Hcount
@onready var salaries: RichTextLabel = $Staff/Salaries
@onready var amount_left: RichTextLabel = $"Staff/Amount left"
@onready var staff: Panel = $Staff

var payroll:int = 0
var Lconsidered:int = 0
var Mconsidered:int = 0
var Hconsidered:int = 0
var consideredSum:int = 0

func open_staff():
	soundfx()
	Global.in_menu = true
	refresh_staff_ui()
	staff.show()

func _on_linput_text_submitted(new_text:int) -> void:
	soundfx()
	Lconsidered = new_text

func _on_minput_text_submitted(new_text:int) -> void:
	soundfx()
	Mconsidered = new_text

func _on_hinput_text_submitted(new_text:int) -> void:
	soundfx()
	Lconsidered = new_text

func _on_hire_pressed() -> void:
	consideredSum = Lconsidered + Mconsidered + Hconsidered
	if consideredSum <= (Global.maxdesks - currentS) and money > (consideredSum * 50000):
		soundfx()
		lowS += Lconsidered
		medS += Mconsidered
		highS += Hconsidered
		payroll = (lowS * 12500) + (medS * 16000) + (highS * 22500)
		money -= (consideredSum * 50000)
		refresh_info_ui()
		refresh_productivity()
		refresh_staff_ui()

func _on_fire_pressed() -> void:
	consideredSum = Lconsidered + Mconsidered + Hconsidered
	if consideredSum <= currentS and money > (consideredSum * 50000):
		lowS -= Lconsidered
		medS -= Mconsidered
		highS -= Hconsidered
		payroll = (lowS * 12500) + (medS * 16000) + (highS * 22500)
		money -= (consideredSum * 50000)
		refresh_info_ui()
		refresh_productivity()
		refresh_staff_ui()

func refresh_staff_ui():
	lcount.text = str(lowS)
	mcount.text = str(medS)
	hcount.text = str(highS)
	salaries.text= "Currently, you are paying a total of $" + str(payroll) + " in salaries."
	amount_left.text = "You have " + str(currentS) + " staff members, meaning your office can hold " + str((Global.maxdesks - currentS)) + " more."

# THE BANK:
@onready var the_bank: Panel = $TheBank

var interestBILL:int = 0
var amount_taken:int = 0
var in_loan = false
var loan_id:int = 0
var MonthLoan:int = 0

@onready var in_loan_menu: Panel = $TheBank/InLoanMenu
@onready var out_loan: Control = $TheBank/OutLoan

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

@onready var rate: Label = $TheBank/InLoanMenu/Detailsposttake/Rate
@onready var term: Label = $TheBank/InLoanMenu/Detailsposttake/Term
@onready var amt_rem: Label = $TheBank/InLoanMenu/Detailsposttake/AmtRem
@onready var bill: Label = $TheBank/InLoanMenu/Detailsposttake/Bill
@onready var early: Label = $TheBank/InLoanMenu/Detailsposttake/Early

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

func _on_loans_pressed() -> void:
	Global.in_menu = true
	the_bank.show()
	refresh_loan()

func _on_pay_pressed() -> void:
	if money > int(amount_taken * .85):
		soundfx()
		money -= int(amount_taken * .85)
		loan_paid()
