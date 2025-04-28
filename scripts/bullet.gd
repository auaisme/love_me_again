extends Node2D

@export var speed = 500
var direction = Vector2.ZERO

@export var lifetime = 2.0  # seconds
var timer = 0.0

@export var damage = 10

func initialize(_direction: Vector2, _speed: float, _damage, _lifetime: float = 2.0) -> void:
	direction = _direction
	speed = _speed
	lifetime = _lifetime
	damage = _damage
	$Area2D/CollisionShape2D/Sprite2D.rotation = direction.angle()
	return
	
func _physics_process(delta: float) -> void:
	timer += delta
	if timer > lifetime || damage <= 0:
		print("timer: " + str(timer) + " damage: " + str(damage))
		queue_free()
		return
	position += direction * speed * delta
	#damage -= 0.1
	return

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	print("collision")
	if body.is_in_group("enemies") || body.is_in_group("walls"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
			pass
		queue_free()
	return
