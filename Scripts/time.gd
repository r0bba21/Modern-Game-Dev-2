extends HBoxContainer

func _on_pause_pressed() -> void:
	Engine.time_scale = 0

func _on_speed_pressed() -> void:
	Engine.time_scale = 2.5

func _on_play_pressed() -> void:
	Engine.time_scale = 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Speed Up"):
		_on_speed_pressed()
	if event.is_action_pressed("0x Speed"):
		_on_pause_pressed()
	if event.is_action_pressed("1x Speed"):
		_on_play_pressed()
