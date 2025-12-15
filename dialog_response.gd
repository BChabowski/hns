extends Control

@export var continue_flag = false
@export var grant_xp_flag = false

func set_text(text: String):
	$DialogResponseButton.text = text
