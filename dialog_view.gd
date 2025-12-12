extends Control

func _ready() -> void:
	hide()
	SignalBus.show_dialog_box.connect(_show_dialog_box)


func _show_dialog_box():
	show()

func _on_close_button_pressed() -> void:
	print("btn press")
	hide()
