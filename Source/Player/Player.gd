class_name Player 
extends KinematicBody2D

signal on_grounded_updated(is_grounded)
signal on_animation_ended()

const SPEED: int = 100
const HORIZONTAL_JUMP_FORCE = 200
const JUMP_FORCE: int = 600
const GRAVITY: int = 1000

export(int) var health_points: int = 100
export(int) var hearts: int = 0
export(int) var base_attack: int = 10

var _velocity: Vector2 = Vector2.ZERO
var _dead: bool = false
var _jumping: bool = false
var _attacking: bool = false
var _ducking: bool = false
var _grounded: bool = true

onready var state_machine: PlayerStateMachine = $PlayerStateMachine

onready var camera: Camera2D = $PlayerCamera
onready var position2D: Position2D = $Position2D
onready var animationTree: AnimationTree = $AnimationTree
onready var whipCollisionShape: CollisionShape2D = $Position2D/AttackHitBox/WhipCollisionShape
onready var playback = animationTree.get("parameters/playback")


func _ready() -> void:
	state_machine.initialize_state_machine(self)
	disable_whipcollitionshape()

func _physics_process(delta: float) -> void:
	ground_check()


##### Métodos####
func _reset_velocity() -> void:
	_velocity = Vector2.ZERO

func flip_sprite():
	if _velocity.x > 0: 
		position2D.scale.x = 1
	elif _velocity.x < 0:
		position2D.scale.x = -1 

func ground_check():
	var was_grounded = _grounded
	_grounded = is_on_floor()
	animationTree.set("parameters/conditions/grounded", _grounded)
	if was_grounded == null || _grounded != was_grounded:
		emit_signal("on_grounded_updated", _grounded)

func animation_ended():
	emit_signal("on_animation_ended")

func set_movement(delta):
	var right = Input.get_action_strength("ui_right")
	var left = Input.get_action_strength("ui_left")
	_velocity.x = right - left
	_velocity.x = _velocity.x * SPEED
	_velocity.y += GRAVITY * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)

func set_gravity(delta):
	_velocity.y += GRAVITY * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)

func set_upward_jump():
	_velocity.y = -JUMP_FORCE
	_velocity = move_and_slide(_velocity, Vector2.UP)

func set_forward_jump():
	if(_velocity.x > 0):
		_velocity.x = HORIZONTAL_JUMP_FORCE
	elif(_velocity.x < 0):
		_velocity.x = -HORIZONTAL_JUMP_FORCE
	_velocity.y = -JUMP_FORCE
	_velocity = move_and_slide(_velocity, Vector2.UP)

func set_movement_momentum():
	_velocity = move_and_slide(_velocity, Vector2.UP)



func disable_whipcollitionshape() -> void:
	whipCollisionShape.disabled = true

func enable_whipcollitionshape() -> void:
	whipCollisionShape.disabled = false





#func _ready_inputs():
#	# Descomentar p/ testar animação de morte, aperte enter p/ testar
##	if Input.get_action_strength("ui_accept"):
##		playback.travel("GetHit")
#
#	if _dead: return
#
#
#
#
#	_attacking = Input.get_action_strength("attack")
#	_jumping = Input.get_action_strength("jump")
#	_ducking = Input.get_action_strength("ducking")
#
#	animationTree.set("parameters/conditions/ducking", !_ducking)
#
#
#
#	if _velocity.x > 0 and not _jumping and not _attacking:
#		if _ducking:
#			playback.travel("Ducking-Walk")
#		else:
#			playback.travel("Walk")
#	elif _velocity.x < 0 and not _jumping and not _attacking:
#		if _ducking:
#			playback.travel("Ducking-Walk")
#		else:
#			playback.travel("Walk")
#	elif _ducking and not _jumping:
#		playback.travel("Ducking")
#	elif _jumping and _grounded and not _attacking and not _ducking:
#		_velocity.y = -JUMP_FORCE
#		playback.travel("Jump")
#
#	if _attacking:
#		whipCollisionShape.disabled = false
#		if _ducking:
#			playback.travel("Ducking-Attack")
#		else:
#			playback.travel("Attack")
