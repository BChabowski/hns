extends NobodyWhoChat

func _ready() -> void:
	self.start_worker()

func ask_character(line: String):
	self.say(line)
