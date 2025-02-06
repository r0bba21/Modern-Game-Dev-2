extends Label

func _ready() -> void:
	match Global.loading_game:
		true:
			self.show()
		false:
			self.hide()
