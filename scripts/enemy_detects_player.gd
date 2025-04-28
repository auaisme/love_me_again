extends Area2D

var parent

func _ready() -> void:
	print("Ready")
	parent = get_parent()
	connect("body_entered", Callable(self, "player_detected"))
	return
	
func player_detected(body) -> void:
	if !(body.is_in_group("player")):
		return
	print("player detected")
	parent.player_body = body
	parent.player_detected = true
	return 
