class_name Player 
extends KinematicBody2D

signal on_grounded_updated(is_grounded)

const SPEED: int = 150
const JUMP_FORCE: int = 700
const GRAVITY: int = 2500

export(int) var health_points: int = 10
export(int) var hearts: int = 0
export(int) var base_attack: int = 1

var _velocity: Vector2 = Vector2.ZERO
var _dead: bool = false
var _jumping: bool = false
var _attacking: bool = false
var _ducking: bool = false
var _grounded: bool = true
var _getting_hit: bool = false
var _intangible: bool = false

onready var camera: Camera2D = $PlayerCamera
onready var position2D: Position2D = $Position2D
onready var animationTree: AnimationTree = $AnimationTree
onready var playerHitBox: Area2D = $PlayerHitBox
onready var playerHitBoxCollisionShape: CollisionShape2D = $PlayerHitBox/CollisionShape2D
onready var whipCollisionShape: CollisionShape2D = $Position2D/AttackHitBox/WhipCollisionShape
onready var playback = animationTree.get("parameters/playback")

func _ready() -> void:
	_set_connections()

func _physics_process(delta: float) -> void:
	_ready_inputs()
	if not _getting_hit:
		_velocity.y += GRAVITY * delta
		_velocity = move_and_slide(_velocity, Vector2.UP)
		
	var was_grounded = _grounded
	_grounded = is_on_floor()
	animationTree.set("parameters/conditions/grounded", _grounded)
	if was_grounded == null || _grounded != was_grounded:
		emit_signal("on_grounded_updated", _grounded)
	
	# Descomentar p/ testar animação de morte
#	_dead = true
#	animationTree.set("parameters/conditions/dead", _dead)

func _reset_state() -> void:
	_velocity = Vector2.ZERO

func _ready_inputs():
	# Descomentar p/ testar animação de morte, aperte enter p/ testar
#	if Input.get_action_strength("ui_accept"):
#		playback.travel("GetHit")
	
	if _dead or _getting_hit: return
	
	var right = Input.get_action_strength("ui_right")
	var left = Input.get_action_strength("ui_left")
	
	_velocity.x = right - left
	_velocity.x = _velocity.x * SPEED
	_attacking = Input.get_action_strength("attack")
	_jumping = Input.get_action_strength("jump")
	_ducking = Input.get_action_strength("ducking")
	
	animationTree.set("parameters/conditions/ducking", !_ducking)

	if _velocity.x > 0: 
		position2D.scale.x = 1
	elif _velocity.x < 0:
		position2D.scale.x = -1 
	
	if _velocity.x > 0 and not _jumping and not _attacking:
		if _ducking:
			playback.travel("Ducking-Walk")
		else:
			playback.travel("Walk")
	elif _velocity.x < 0 and not _jumping and not _attacking:
		if _ducking:
			playback.travel("Ducking-Walk")
		else:
			playback.travel("Walk")
	elif _ducking and not _jumping:
		playback.travel("Ducking")
	elif _jumping and _grounded and not _attacking and not _ducking:
		_velocity.y = -JUMP_FORCE
		playback.travel("Jump")
		
	if _attacking:
		whipCollisionShape.disabled = false
		if _ducking:
			playback.travel("Ducking-Attack")
		else:
			playback.travel("Attack")

func disable_whipcollitionshap() -> void:
	whipCollisionShape.disabled = true

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy and not _intangible:
		print("dano")
		if health_points > 0:
			health_points -= 1
			PlayerVariables.health = health_points
			playback.travel("GetHit")
			_getting_hit = true
			playerHitBoxCollisionShape.set_deferred("disable", true)
			yield(get_tree().create_timer(0.4), "timeout")
			_getting_hit = false
			_intangible = true
			playerHitBoxCollisionShape.set_deferred("disable", false)
			yield(get_tree().create_timer(1.0), "timeout")
			_intangible = false
		else:
			_dead = true
			animationTree.set("parameters/conditions/dead", _dead)

func _set_connections() -> void:
	playerHitBox.connect("body_entered", self, "_on_body_entered")
	pass
