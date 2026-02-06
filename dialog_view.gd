extends Control

var npc_id
var dialog_root_id = -1
var next_dialog_id: int
var dialog_supplier: Node
var npc: Node2D

func _ready() -> void:
	hide()
	dialog_supplier = preload("res://dialog_supplier.gd").new()
	SignalBus.show_dialog_box.connect(_show_dialog_box)
	SignalBus.dialog_finished.connect(_load_responses)

func _show_dialog_box(current_npc: Node2D):
	npc = current_npc
	$AIModule/AIChat.start_module(npc)
	self.npc_id = current_npc.npc_id
	SignalBus.dialog_updated.connect(_load_ai_dialog)
	#$AIModule/AIChat.respond("Hello", current_npc)
	#_load_dialog(dialog_root_id)
	_generate_npc_dialog("Hello", npc)
	next_dialog_id = dialog_root_id
	#_load_responses(dialog_root_id, "Hello")
	show()

func _load_ai_dialog(token):
	$NpcTextContainer/NpcText.text = $NpcTextContainer/NpcText.text + token

#func _load_dialog(dialog_id: int):
	#
	#$NpcTextContainer/NpcText.text = dialog_supplier.get_dialog_text(npc_id, dialog_id)

func _generate_npc_dialog(dialog_line: String, npc: Node2D):
	$AIModule/AIChat.respond(dialog_line, npc)

func _load_responses():
	var responses: Array[Node] = dialog_supplier.get_dialog_responses(npc_id, next_dialog_id)
	#todo find a way to add buttons programatically in a nice list
	var response = responses[0]
	# todo responses should have flags - and actions should be assigned to them based on this flags
	# simple if statements will do
	response.get_child(0).pressed.connect(_on_click_continue.bind(response))
	$PlayerDialogLinesContainer/ScrollContainer/VBoxContainer.add_child(response)
	var close = responses[1]
	#close.text = "Close"
	close.get_child(0).pressed.connect(_on_close_button_pressed)
	$PlayerDialogLinesContainer/ScrollContainer/VBoxContainer.add_child(close)

### button on_click functions
func _on_click_continue(response: Node):
	$NpcTextContainer/NpcText.text = ""
	for node in $PlayerDialogLinesContainer/ScrollContainer/VBoxContainer.get_children():
		node.queue_free()
	next_dialog_id = response.next_dialog_id
	_generate_npc_dialog(response.dialog_line_text, npc)
	#_load_responses(response.next_dialog_id, response.dialog_line_text)
###

func _on_close_button_pressed() -> void:
	hide()
