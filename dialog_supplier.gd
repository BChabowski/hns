extends Node

func get_dialog_text(npc_id: int, dialog_id: int):
	return "Hello there! It's a me, AI!"

func get_dialog_responses(npc_id: int, dialog_id: int):
	#todo accept dialog_response.tscn as a parameter?
	#todo return array
	var dialog_response = preload("res://dialog_response.tscn").instantiate()
	dialog_response.continue_flag = true
	dialog_response.set_text("Hello.")
	return dialog_response
