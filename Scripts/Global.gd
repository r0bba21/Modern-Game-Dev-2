extends Node

# DEPRECATED:
var in_menu = false

# IMPORTANT:
var gameinprog = false

# OPTIONS MENU:
var chosen_sfx:int = 1
var resindex:int = 0
var fsindex:int = 0
var mastervol:float = 1
var sfxvol:float = 1
var musicvol:float = 1
var autosave:int = 0

# DIFFICULTY:
var loans = true
var pubs = true
var conts = true
var resM = true
var prodM:float = 1
var priceM:float = 1
var salesM:float = 1
var fansM:float = 1
var expM: float = 1

# RESEARCH:
var research_tokens:int = 0
var research_level:int = 0
var in_research = false
var PROD_research:float = 1

# MONEY ACROSS SCRIPTS:
var charge:int = 0

# CONTRACTS:
var in_contract = false

# STAFF:
var maxdesks:int = 5
var office_id:int = 0

# LOADING GAME:
var loading_game = false

# COMPANY:
var CompName:String = "Cool Games Co."
var FoundName:String = "Poo Jones"
var CopiesSold:int = 0
var LogoID:int = 0
var LogoCOL:Color = "ffffff"
var officeCOL:Color = "ffffff"

# STOCKS:
var Sunits:float = 0

# PAUSE MENU
var in_pause = false
var loading_custom = false

# PORTFOLIO:
var LatestName:String = "sex"
var LatestUnits:int = 12
var LatestQual:float = 24
var LatestRev:int = 36
