extends Node2D

func _on_easy_pressed() -> void:
	Global.difficulty = 1
	get_tree().change_scene_to_file("res://Scenes/office.tscn")

func _on_normal_pressed() -> void:
	Global.difficulty = 2
	get_tree().change_scene_to_file("res://Scenes/office.tscn")

func _on_hard_pressed() -> void:
	Global.difficulty = 3
	get_tree().change_scene_to_file("res://Scenes/office.tscn")

func _on_impossible_pressed() -> void:
	Global.difficulty = 4
	get_tree().change_scene_to_file("res://Scenes/office.tscn")
