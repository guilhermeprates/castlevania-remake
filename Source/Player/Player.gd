class_name Player extends KinematicBody2D

signal on_grounded_updated(is_grounded)

const SPEED: int = 200
const JUMP_SPEED: int = 800
const GRAVITY: int = 2500

onready var sprite: AnimatedSprite = $AnimatedSprite
onready var camera: Camera2D = $PlayerCamera

export(int) var health_points: int = 200
export(int) var mana_points: int = 100
export(int) var base_attack: int = 10

var velocity: Vector2 = Vector2.ZERO
var is_jumping: bool = false
var is_grounded: bool = true

func _ready() -> void:
	_set_connections()

func _physics_process(delta: float) -> void:
	_get_input()
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var was_grounded  = is_grounded
	is_grounded = is_on_floor()
	if was_grounded == null || is_grounded != was_grounded:
		emit_signal("on_grounded_updated", is_grounded)

func _get_input():
	velocity.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	velocity.x = velocity.x * SPEED
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_SPEED
	
	if velocity.x < 0:
		sprite.flip_h = false
		sprite.play("walk")
	elif velocity.x > 0:
		sprite.flip_h = true
		sprite.play("walk")
	else:
		sprite.frame = 0
		sprite.stop()

func _set_connections() -> void:
	pass
