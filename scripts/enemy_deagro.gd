extends Area2D

var parent: CharacterBody2D

func _ready() -> void:
	parent = get_parent()
	connect("body_exited", deagro)
	return
	
func deagro(body) -> void:
	if !body.is_in_group("player"):
		return
	parent.player_body = null
	parent.player_detected = false
	parent.last_known_player_position = body.global_position
	return
