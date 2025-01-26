extends Control
func _ready() -> void:
	soundfx()
	difficulty_select()

# CONTROL:
var rent:int = 1500
var in_menu = false
var gameinprog = false
var fans:int = 0
var months:int = 0
var years:int = 0
var money:int = 65000
var productivity = 1
var currentS: int = 0
var highS: int = 0
var lowS: int = 0
var medS:int = 0
var expenses:int = rent

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
