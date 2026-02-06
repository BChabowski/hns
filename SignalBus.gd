extends Node

signal object_clicked(obj: Node2D)
signal xp_granted(xp: int)
signal player_xp_changed(xp: int, xp_to_next_level: int)
signal player_hp_changed(new_hp: int, max_hp: int)
signal show_dialog_box(npc: Node2D)
signal dialog_line_chosen(dialog_line: Button)

signal dialog_updated(next_word: String)
signal dialog_finished
