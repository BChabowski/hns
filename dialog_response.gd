extends Control

@export var continue_flag = false
@export var grant_xp_flag = false
@export var end_conversation = false
@export var next_dialog_id: int
@export var dialog_line_text: String

func _ready() -> void:
	$DialogResponseButton.flat = true

func set_text(text: String):
	dialog_line_text = text
	$DialogResponseButton.text = text

func set_on_click(method: Callable):
	method.call()
