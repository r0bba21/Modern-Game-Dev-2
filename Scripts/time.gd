extends HBoxContainer

func _on_pause_pressed() -> void:
	Engine.time_scale = 0.0
	pause.disabled = true

func _on_speed_pressed() -> void:
	Engine.time_scale = 2.5

func _on_play_pressed() -> void:
	Engine.time_scale = 1.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Speed Up"):
		_on_speed_pressed()
	if event.is_action_pressed("0x Speed"):
		_on_pause_pressed()
	if event.is_action_pressed("1x Speed"):
		_on_play_pressed()

@onready var pause: Button = $Pause
@onready var _1x: Button = $"1x"
@onready var speed: Button = $Speed

func _process(delta: float) -> void:
	pause.disabled = false
	_1x.disabled = false
	speed.disabled = false
	match Engine.time_scale:
		0.0:
			pause.disabled = true
		1.0:
			_1x.disabled = true
		2.5:
			speed.disabled = true
