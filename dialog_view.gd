extends Control

var npc_id
var dialog_root_id = -1
var dialog_supplier: Node

func _ready() -> void:
	hide()
	dialog_supplier = preload("res://dialog_supplier.gd").new()
	SignalBus.show_dialog_box.connect(_show_dialog_box)

func _show_dialog_box(current_npc_id: int):
	self.npc_id = current_npc_id
	_load_dialog(dialog_root_id)
	_load_responses(dialog_root_id)
	show()

func _load_dialog(dialog_id: int):
	$NpcTextContainer/NpcText.text = dialog_supplier.get_dialog_text(npc_id, dialog_id)

func _load_responses(dialog_id: int):
	for node in $PlayerDialogLinesContainer/ScrollContainer.get_children():
		node.queue_free()
	var response: Node = dialog_supplier.get_dialog_responses(npc_id, dialog_id)
	#todo find a way to add buttons programatically in a nice list
	response.get_child(0).pressed.connect(_on_click_continue.bind(response))
	$PlayerDialogLinesContainer/ScrollContainer.add_child(response)

### button on_click functions
func _on_click_continue(response: Node):
	_load_dialog(response.next_dialog_id)
	_load_responses(response.next_dialog_id)
###

func _on_close_button_pressed() -> void:
	print("btn press")
	hide()
