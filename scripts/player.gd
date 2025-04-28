extends CharacterBody2D

# Movement speed in pixels per second
@export var speed: float = 1000.0
var direction

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_custom_mouse_cursor(load("res://circle-ar-aim-cursor.png"))
	return

# this runs every frame
func _process(delta: float) -> void:
	weapon_select()
	point_player_at_mouse()
	if Input.is_action_just_pressed("shoot"):
		shoot()
	return

# this also runs every frame
func _physics_process(delta: float) -> void:
	var input_vector = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	velocity = input_vector * speed
	
	if velocity != Vector2.ZERO:
		$Sprite2D.visible = false
		$WalkAnimation.visible = true
		$WalkAnimation.play("default")
		pass
	else:
		$WalkAnimation.stop()
		$WalkAnimation.visible = false
		$Sprite2D.visible = true
		pass
	
	move_and_slide()

func point_player_at_mouse():
	var global_mouse_pos = get_global_mouse_position()
	direction = global_mouse_pos - $Sprite2D.global_position
	$Sprite2D.rotation = direction.angle()
	#direction = global_mouse_pos - $ShotgunAimSprite.global_position
	$ShotgunAimSprite.rotation = direction.angle()
	#direction = global_mouse_pos - $PointLight2D.global_position
	$PointLight2D.rotation = direction.angle()
	$WalkAnimation.rotation = direction.angle()
	return

func weapon_select() -> void:
	# if possible, replace this if tree with switch
	# or better yet replace with array
	# or even better have callbacks
	if Input.is_physical_key_pressed(KEY_1):
		$ShotgunAimSprite.set_visible(false)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.set_custom_mouse_cursor(load("res://circle-ar-aim-cursor.png"))
		return
	if Input.is_physical_key_pressed(KEY_2):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		$ShotgunAimSprite.set_visible(true)
		return
	return

@export var bullet_scene: PackedScene

func shoot() -> void:
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	#bullet.rotation = $Sprite2D.global_rotation
	#bullet.direction = direction
	bullet.initialize(direction, 10, 10.0, 0.5)
	return
