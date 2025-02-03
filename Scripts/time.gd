extends VBoxContainer

func _on_pause_pressed() -> void:
	if Engine.time_scale != 0:
		Engine.time_scale = 0
	else:
		Engine.time_scale = 1
	refresh_buttons()

func _on_speed_pressed() -> void:
	if Engine.time_scale != 2.5:
		Engine.time_scale = 2.5
	else:
		Engine.time_scale = 1
	refresh_buttons()

@onready var pause: Button = $Pause
@onready var speed: Button = $Speed

func refresh_buttons():
	if Engine.time_scale == 0:
		pause.text = " Play "
		speed.text = " 2.5x "
	if Engine.time_scale == 1:
		pause.text = " Pause "
		speed.text = " 2.5x "
	if Engine.time_scale == 2.5:
		pause.text = " Pause "
		speed.text = " 1x  "

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Speed Up"):
		_on_speed_pressed()
	if event.is_action_pressed("0x Speed"):
		_on_pause_pressed()
	if event.is_action_pressed("1x Speed"):
		Engine.time_scale = 0
		_on_pause_pressed()
