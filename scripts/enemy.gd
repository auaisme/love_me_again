extends CharacterBody2D

@export var health = 10
@export var speed: float

var player_detected = false
var player_body: CharacterBody2D = null
var last_known_player_position: Vector2 = Vector2.ZERO
var is_moving = false

func _ready() -> void:
	if !speed || speed < 0:
		speed = 100

func take_damage(damage: float = 1.0):
	health -= damage
	print("Took " + str(damage) + " damage, new health: " + str(health))
	return
	
func _process(delta: float) -> void:
	if is_moving:
		$footprints.visible = true
		if !$footprints.is_playing():
			$footprints.play("default")
	else:
		$footprints.stop()
		$footprints.visible = false
	if health <= 0:
		queue_free()
		return
	if player_detected:
		move_to_player()
		return
	if last_known_player_position != Vector2.ZERO:
		rotate_towards_target(last_known_player_position)
		move(last_known_player_position)
		return
	return

func move_to_player() -> void:
	if !player_detected || !player_body:
		print("Player Detection: " + str(player_detected) + " Player body: " + str(player_body))
		return
	rotate_towards_target(player_body.position)
	move(player_body.position)
	return

func rotate_towards_target(target) -> void:
	self.rotation = (self.global_position - target).angle()
	return

func move(target) -> void:
	#print("Enemy at " + str(self.global_position))
	#print("Target at " + str(target))
	var temp = target - global_position
	if temp.x < 5 && temp.y < 5 && temp.x > -5 && temp.y > -5:
		last_known_player_position = Vector2.ZERO
		is_moving = false
		return
	temp = temp.normalized()
	#temp = temp * -1
	#print("Difference " + str(temp))
	velocity = temp * speed
	move_and_slide()
	is_moving = true
	return

func footprints() -> void:
	$footprints.play("default")
	return
