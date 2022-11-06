class_name Player 
extends KinematicBody2D

signal on_grounded_updated(is_grounded)
signal on_animation_ended()
signal on_player_damaged()


const SPEED: int = 150
const HORIZONTAL_JUMP_FORCE = 200
const JUMP_FORCE: int = 700
const GRAVITY: int = 2500

var knockback_dir = 1 

export(int) var health_points: int = 10
export(int) var hearts: int = 0
export(int) var base_attack: int = 1


var _knockback = Vector2.ZERO
var _velocity: Vector2 = Vector2.ZERO
var _dead: bool = false
var _jumping: bool = false
var _attacking: bool = false
var _ducking: bool = false
var _grounded: bool = true
var _getting_hit: bool = false
var _intangible: bool = false
var _freezeControl = false 

onready var state_machine: PlayerStateMachine = $PlayerStateMachine

onready var camera: Camera2D = $PlayerCamera
onready var position2D: Position2D = $Position2D
onready var animationTree: AnimationTree = $AnimationTree

onready var playerFrontalHitBox: Area2D = $Position2D/FrontalHitBox
onready var playerFrontalHitBoxCollision: CollisionShape2D = $Position2D/FrontalHitBox/CollisionShape2D
onready var playerBackHitBox: Area2D = $Position2D/BackHitBox
onready var playerBackHitBoxCollision: CollisionShape2D = $Position2D/BackHitBox/CollisionShape2D

onready var whipCollisionShape: CollisionShape2D = $Position2D/AttackHitBox/WhipCollisionShape
onready var playback = animationTree.get("parameters/playback")

func _ready() -> void:
	PlayerVariables.health_points = health_points
	state_machine.initialize_state_machine(self)
	_set_connections()

func _physics_process(delta: float) -> void:
	ground_check()
#	_ready_inputs()
#	if not _getting_hit:
#		_velocity.y += GRAVITY * delta
#		_velocity = move_and_slide(_velocity, Vector2.UP)
#
#	var was_grounded = _grounded
#	_grounded = is_on_floor()
#	animationTree.set("parameters/conditions/grounded", _grounded)
#	if was_grounded == null || _grounded != was_grounded:
#		emit_signal("on_grounded_updated", _grounded)
	
	# distancia do empurrao:
#	_knockback = _knockback.move_toward(Vector2.ZERO, 10 * delta)
#	_knockback = move_and_slide(_knockback)
	move_and_collide(_knockback)

func _reset_state() -> void:
	_velocity = Vector2.ZERO
	_knockback = Vector2.ZERO

func _ready_inputs():
	if _dead or _getting_hit: return
	
	var right = Input.get_action_strength("ui_right")
	var left = Input.get_action_strength("ui_left")
	
	_velocity.x = right - left
	_velocity.x = _velocity.x * SPEED
	_attacking = Input.get_action_strength("attack")
	_jumping = Input.get_action_strength("jump")
	_ducking = Input.get_action_strength("ducking")
	
	# p/ q o player não fique abaixado sem apertar o botão
	animationTree.set("parameters/conditions/ducking", !_ducking)

	if _velocity.x > 0: 
		position2D.scale.x = 1
		knockback_dir = _velocity
	elif _velocity.x < 0:
		position2D.scale.x = -1 
		knockback_dir = _velocity
	
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




func _on_body_entered(body: Node2D) -> void:
	if body is Enemy and not _intangible:
		
		print(body)
		emit_signal("on_player_damaged")
##		_knockback = Vector2.LEFT * 400
##		_velocity.y = -200 # pulinho 
#		if health_points > 1:
#			health_points -= 1
#			PlayerVariables.health_points = health_points
#			playback.travel("GetHit")
#			_getting_hit = true
#			playerFrontalHitBoxCollision.set_deferred("disable", true)
#			yield(get_tree().create_timer(0.4), "timeout")
#			_getting_hit = false
#			_intangible = true
#			playerFrontalHitBoxCollision.set_deferred("disable", false)
#			yield(get_tree().create_timer(1.0), "timeout")
#			_intangible = false
#		else:
#			health_points -= 1
#			PlayerVariables.health_points = health_points
#			_dead = true
#			animationTree.set("parameters/conditions/dead", _dead)
#			playback.travel("GetHit")

func _set_connections() -> void:
	playerFrontalHitBox.connect("body_entered", self, "_on_body_entered")
	playerBackHitBox.connect("body_entered", self, "_on_body_entered")



##### Métodos####
func _reset_velocity() -> void:
	_velocity = Vector2.ZERO

func flip_sprite():
	if _velocity.x > 0: 
		position2D.scale.x = 1
	elif _velocity.x < 0:
		position2D.scale.x = -1 

func take_damage():
	health_points -= 1
	PlayerVariables.health_points = health_points

func disable_player_hitboxes():
	playerFrontalHitBoxCollision.set_deferred("disable", true)
	playerBackHitBoxCollision.set_deferred("disable", true)


func enable_player_hitboxes():
	playerFrontalHitBoxCollision.set_deferred("disable", false)
	playerBackHitBoxCollision.set_deferred("disable", false)


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

func set_knockback():
	_velocity = Vector2(1,-1) * 500
	_velocity = move_and_slide(_velocity, Vector2.UP)



func set_movement_momentum():
	_velocity = move_and_slide(_velocity, Vector2.UP)


func enable_whip_collision_shape() -> void:
	whipCollisionShape.disabled = false

func disable_whip_collision_shape() -> void:
	whipCollisionShape.disabled = true
