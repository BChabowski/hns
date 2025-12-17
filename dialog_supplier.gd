extends Node

func get_dialog_text(npc_id: int, dialog_id: int):
	if dialog_id == -1:
		return "Hello there! It's a me, AI!"
	else: 
		return "What's up, doc?"

func get_dialog_responses(npc_id: int, dialog_id: int) -> Array[Node]:
	var responses: Array[Node] = []
	#todo accept dialog_response.tscn as a parameter?
	#todo return array
	var dialog_response = preload("res://dialog_response.tscn").instantiate()
	dialog_response.continue_flag = true
	if dialog_id == -1:
		dialog_response.set_text("Hello.")
		dialog_response.next_dialog_id = 0
	else:
		dialog_response.set_text("OK.")
		dialog_response.next_dialog_id = 1
	responses.append(dialog_response)
	var close = preload("res://dialog_response.tscn").instantiate()
	close.end_conversation = true
	close.set_text("Close")
	responses.append(close)
	
	return responses
