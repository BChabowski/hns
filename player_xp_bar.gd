extends TextureProgressBar

var xp_label: Label
var xp_label_content: String

func _ready() -> void:
	xp_label = $XpValueLabel
	xp_label.hide()
	SignalBus.player_xp_changed.connect(_on_player_xp_changed)

func _on_player_xp_changed(current_xp: int, xp_to_next_level: int):
	max_value = xp_to_next_level
	value = current_xp
	xp_label_content = str(current_xp) + "/" + str(xp_to_next_level)
	xp_label.text = xp_label_content


func _on_mouse_entered() -> void:
	xp_label.show()

func _on_mouse_exited() -> void:
	xp_label.hide()
