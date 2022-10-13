class_name Player 
extends KinematicBody2D

signal on_grounded_updated(is_grounded)

const SPEED: int = 200
const JUMP_SPEED: int = 800
const GRAVITY: int = 2500

export(int) var health_points: int = 200
export(int) var mana_points: int = 100
export(int) var base_attack: int = 10

var _velocity: Vector2 = Vector2.ZERO
var _jumping: bool = false
var _attacking: bool = false
var _grounded: bool = true

onready var camera: Camera2D = $PlayerCamera
onready var sprite: Sprite = $Sprite
onready var animationTree: AnimationTree = $AnimationTree

func _ready() -> void:
	_set_connections()

func _physics_process(delta: float) -> void:
	_ready_inputs()
	_velocity.y += GRAVITY * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)
	
	var was_grounded = _grounded
	_grounded = is_on_floor()
	if was_grounded == null || _grounded != was_grounded:
		emit_signal("on_grounded_updated", _grounded)

func _reset_state() -> void:
	_velocity = Vector2.ZERO

func _ready_inputs():
	_velocity.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	_velocity.x = _velocity.x * SPEED
	
	var playback = animationTree.get("parameters/playback")
	
	if _velocity.x > 0 and not _attacking:
		sprite.flip_h = false
		playback.travel("Walk")
	elif _velocity.x < 0 and not _attacking:
		sprite.flip_h = true
		playback.travel("Walk")
	else:
		if not _attacking:
			playback.travel("Idle")
#			
#	if Input.get_action_strength("attack"):
#		sprite.play("attacking")
#		_is_attacking = true

func _set_connections() -> void:
	pass
