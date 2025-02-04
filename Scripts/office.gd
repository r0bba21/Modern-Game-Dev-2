extends Node2D

var PCcol:StandardMaterial3D = load("res://Assets/Backdrops/PC emission.tres") as StandardMaterial3D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func color_change():
	var STARTERcol:StandardMaterial3D = load("res://Assets/Backdrops/starter.tres") as StandardMaterial3D
	STARTERcol.albedo_color = Global.officeCOL # STARTER, AMATEUR AND SMALL
	var MEDcol: StandardMaterial3D = load("res://Assets/Backdrops/MED.tres") as StandardMaterial3D
	MEDcol.albedo_color = Global.officeCOL
	var LRGcol: StandardMaterial3D = load("res://Assets/Backdrops/LRG.tres") as StandardMaterial3D
	LRGcol.albedo_color = Global.officeCOL
