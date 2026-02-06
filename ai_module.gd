extends NobodyWhoChat

func start_module(npc: Node2D):
	print(npc.system_prompt)
	self.system_prompt = npc.system_prompt
	self.start_worker()

func respond(dialog_line_text: String, npc: Node2D):
	#print(npc.system_prompt)
	#self.system_prompt = npc.system_prompt
	#self.start_worker()
	self.say(dialog_line_text)

func _on_response_updated(new_token: String) -> void:
	print(new_token)
	SignalBus.dialog_updated.emit(new_token)

func _on_response_finished(response: String) -> void:
	SignalBus.dialog_finished.emit()
