extends Node2D

@onready var starter_office: AnimatedSprite2D = $StarterOffice
@onready var starter_anims: AnimationPlayer = $StarterOffice/StarterAnims
@onready var amateur_office: AnimatedSprite2D = $AmateurOffice
@onready var amateur_anims: AnimationPlayer = $AmateurOffice/AmateurAnims
@onready var small_office: AnimatedSprite2D = $SmallOffice
@onready var small_anims: AnimationPlayer = $SmallOffice/SmallAnims
@onready var med_office: AnimatedSprite2D = $MedOffice
@onready var med_anims: AnimationPlayer = $MedOffice/MedAnims
@onready var large_office: AnimatedSprite2D = $LargeOffice
@onready var large_anims: AnimationPlayer = $LargeOffice/LargeAnims
@onready var sky_office: AnimatedSprite2D = $SkyOffice
@onready var sky_anims: AnimationPlayer = $SkyOffice/SkyAnims

func _process(delta: float) -> void:
	match Global.office_id:
		0:
			amateur_office.hide()
			small_office.hide()
			med_office.hide()
			large_office.hide()
			sky_office.hide()
			starter()
		1:
			starter_office.hide()
			amateur_office.show()
			small_office.hide()
			med_office.hide()
			large_office.hide()
			sky_office.hide()
			amateur()
		2:
			starter_office.hide()
			amateur_office.hide()
			small_office.show()
			med_office.hide()
			large_office.hide()
			sky_office.hide()
			small()
		3:
			starter_office.hide()
			amateur_office.hide()
			small_office.hide()
			med_office.show()
			large_office.hide()
			sky_office.hide()
			medium()
		4:
			starter_office.hide()
			amateur_office.hide()
			small_office.hide()
			med_office.hide()
			large_office.show()
			sky_office.hide()
			large()
		5:
			starter_office.hide()
			amateur_office.hide()
			small_office.hide()
			med_office.hide()
			large_office.hide()
			sky_office.show()
			skyscraper()

func amateur():
	pass

func small():
	pass

func medium():
	pass

func large():
	pass

func skyscraper():
	pass

func starter():
	if Global.gameinprog == false and Global.in_contract == false and Global.in_research == false:
		starter_anims.assigned_animation = "Idle"
	if Global.gameinprog == true:
		starter_anims.assigned_animation = "Dev"
	if Global.in_research == true:
		starter_anims.assigned_animation = "Research"
	if Global.in_contract == true:
		starter_anims.assigned_animation = "Contract"
