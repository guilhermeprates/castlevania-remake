class_name Player extends KinematicBody2D

export (int) var speed: int = 250
export (int) var rotation_speed: int = 1.5
export (int) var gravity: int = 2500
export (int) var jump_speed: int = 900

var velocity: Vector2 = Vector2()

onready var sprite: AnimatedSprite = $AnimatedSprite

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	_get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func _get_input():
	velocity.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	velocity.x = velocity.x * speed
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_speed
		
	if velocity.x < 0:
		sprite.play("walk")
	elif velocity.x > 0:
		sprite.play("walk")
	else:
		sprite.frame = 0
		sprite.stop()
