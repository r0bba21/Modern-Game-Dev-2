extends Node2D

var PCcol:StandardMaterial3D = load("res://Assets/Backdrops/PC emission.tres") as StandardMaterial3D

@onready var starter: Node3D = $STARTER
@onready var amateur: Node3D = $AMATEUR
@onready var small: Node3D = $SMALL
@onready var medium: Node3D = $MEDIUM
@onready var large: Node3D = $LARGE
@onready var sky: Node3D = $SKY

func _process(delta: float) -> void:
	starter.hide()
	amateur.hide()
	small.hide()
	medium.hide()
	large.hide()
	sky.hide()
	match Global.office_id:
		0:
			starter.show()
			$STARTER/Camera.set_current(true)
		1:
			amateur.show()
			$AMATEUR/Camera.set_current(true)
		2:
			small.show()
			$SMALL/Camera.set_current(true)
		3:
			medium.show()
			$MEDIUM/Camera.set_current(true)
		4:
			large.show()
			$LARGE/Camera.set_current(true)
		5:
			sky.show()
			$SKY/Camera.set_current(true)
	var STARTERcol:StandardMaterial3D = load("res://Assets/Backdrops/starter.tres") as StandardMaterial3D
	if Global.officeCOL != STARTERcol.albedo_color:
		color_change()
	pc_col()

func color_change():
	var STARTERcol:StandardMaterial3D = load("res://Assets/Backdrops/starter.tres") as StandardMaterial3D
	STARTERcol.albedo_color = Global.officeCOL # STARTER, AMATEUR AND SMALL
	var MEDcol: StandardMaterial3D = load("res://Assets/Backdrops/MED.tres") as StandardMaterial3D
	MEDcol.albedo_color = Global.officeCOL
	var LRGcol: StandardMaterial3D = load("res://Assets/Backdrops/LRG.tres") as StandardMaterial3D
	LRGcol.albedo_color = Global.officeCOL # LRG AND SKY
	var Acol:StandardMaterial3D = load("res://Assets/Backdrops/ACCENT.tres") as StandardMaterial3D
	Acol.albedo_color = Global.officeCOL

func pc_col():
	var PC:StandardMaterial3D = load("res://Assets/Backdrops/PC emission.tres") as StandardMaterial3D
	if Global.in_research != true and Global.in_contract != true and Global.gameinprog != true:
		PC.emission_enabled = false
		PC.emission = "ffffff"
		PC.emission_energy_multiplier = 0
	if Global.in_research != false:
		PC.emission_enabled = true
		PC.emission = "85ffff"
		PC.emission_energy_multiplier = 1.8
	if Global.gameinprog != false:
		PC.emission_enabled = true
		PC.emission = "85ff87"
		PC.emission_energy_multiplier = 1.9
	if Global.in_contract != false:
		PC.emission_enabled = true
		PC.emission = "ff8369"
		PC.emission_energy_multiplier = 1.7
