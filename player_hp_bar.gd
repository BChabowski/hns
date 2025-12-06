extends TextureProgressBar

var hp_label_conent: String
var hp_label: Label

func _ready() -> void:
	hp_label = $HpValueLabel
	hp_label.hide()
	SignalBus.player_hp_changed.connect(_on_player_hp_changed)

func _on_player_hp_changed(new_hp: int, max_hp: int):
	max_value = max_hp
	value = new_hp
	hp_label_conent = str(new_hp) + "/" + str(max_hp)
	hp_label.text = hp_label_conent


func _on_mouse_entered() -> void:
	hp_label.show()

func _on_mouse_exited() -> void:
	hp_label.hide()
