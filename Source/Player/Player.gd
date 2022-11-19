class_name Player 
extends KinematicBody2D

signal on_grounded_updated(is_grounded)
signal on_animation_ended()
signal on_player_damaged()


const SPEED: int = 150
const HORIZONTAL_JUMP_FORCE = 200
const JUMP_FORCE: int = 700
const GRAVITY: int = 2500

#var knockback_dir = 1 

export(int) var health_points: int = 16
export(int) var hearts: int = 0
export(int) var base_attack: int = 1



var _velocity: Vector2 = Vector2.ZERO
var _grounded: bool = true
var _intangible: bool = false
var _is_facing_right = true

#var _dead: bool = false
#var _jumping: bool = false
#var _attacking: bool = false
#var _ducking: bool = false
#var _getting_hit: bool = false
#var _freezeControl = false 
#var _knockback = Vector2.ZERO

onready var state_machine = $PlayerStateMachine
onready var sprite: Sprite = $Position2D/Sprite

onready var camera: Camera2D = $PlayerCamera
onready var position2D: Position2D = $Position2D
onready var animationTree: AnimationTree = $AnimationTree

######## Collider References ################
onready var playerMainCollision : CollisionShape2D = $PlayerCollisionShape
onready var playerShortCollison: CollisionShape2D = $ShortCollisionShape

onready var playerFrontalHitBox: Area2D = $Position2D/FrontalHitBox
onready var playerFrontalHitBoxCollision: CollisionShape2D = $Position2D/FrontalHitBox/CollisionShape2D
onready var shortFrontalHitBoxCollision: CollisionShape2D = $Position2D/FrontalHitBox/ShortCollisionShape

onready var playerBackHitBox: Area2D = $Position2D/BackHitBox
onready var playerBackHitBoxCollision: CollisionShape2D = $Position2D/BackHitBox/CollisionShape2D
onready var shortBackHitBoxCollision: CollisionShape2D = $Position2D/BackHitBox/ShortCollisionShape

onready var whipCollisionShape: CollisionShape2D = $Position2D/AttackHitBox/WhipCollisionShape




onready var playback = animationTree.get("parameters/playback")

func _ready() -> void:
	Game.player_health_points = health_points
	state_machine.initialize_state_machine(self)
	_set_connections()
	disable_short_hitboxes()

func _physics_process(delta: float) -> void:
	ground_check()


func _on_body_entered_front(body: Node2D) -> void:
	if body is Enemy and not _intangible:
		_intangible = true
		emit_signal("on_player_damaged")

func _on_body_entered_back(body: Node2D) -> void:
	if body is Enemy and not _intangible:
		_intangible = true
		position2D.scale.x *= -1
		if(_is_facing_right):
			_is_facing_right = false
		else:
			_is_facing_right = true
		emit_signal("on_player_damaged")


##### Métodos####
func _reset_velocity() -> void:
	_velocity = Vector2.ZERO

func flip_sprite():
	if _velocity.x > 0: 
		position2D.scale.x = 1
		_is_facing_right = true
	elif _velocity.x < 0:
		position2D.scale.x = -1
		_is_facing_right = false 


func back_from_hit():
	sprite.modulate.a = 0
	yield(get_tree().create_timer(0.1), "timeout")
	sprite.modulate.a = 1
	yield(get_tree().create_timer(0.1), "timeout")
	sprite.modulate.a = 0
	yield(get_tree().create_timer(0.1), "timeout")
	sprite.modulate.a = 1
	yield(get_tree().create_timer(0.1), "timeout")
	sprite.modulate.a = 0
	yield(get_tree().create_timer(0.1), "timeout")
	sprite.modulate.a = 1
	yield(get_tree().create_timer(0.1), "timeout")
	sprite.modulate.a = 0
	yield(get_tree().create_timer(0.1), "timeout")
	sprite.modulate.a = 1
	yield(get_tree().create_timer(0.1), "timeout")
	sprite.modulate.a = 0
	yield(get_tree().create_timer(0.1), "timeout")
	sprite.modulate.a = 1
	yield(get_tree().create_timer(0.1), "timeout")
	_intangible = false



func take_damage():
	health_points -= 1
	Game.player_health_points = health_points


func enable_short_hitboxes():
	playerShortCollison.disabled = false
	shortFrontalHitBoxCollision.disabled = false
	shortBackHitBoxCollision.disabled = false
	
	playerMainCollision.disabled = true
	playerFrontalHitBoxCollision.disabled = true
	playerBackHitBoxCollision.disabled = true
	



func disable_short_hitboxes():
	playerMainCollision.disabled = false
	playerFrontalHitBoxCollision.disabled = false
	playerBackHitBoxCollision.disabled = false
	
#	playerShortCollison.disabled = true
	shortFrontalHitBoxCollision.disabled = true
	shortBackHitBoxCollision.disabled = true




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
	_velocity = move_and_slide(_velocity, Vector2.UP, true)

func set_stairway_movement(delta):
	var up = Input.get_action_strength("ui_up")
	var down = Input.get_action_strength("ui_down")
		
	_velocity.x = up - down
	_velocity.x = _velocity.x * SPEED * 0.7
#	_velocity.y += GRAVITY * delta
	_velocity = move_and_slide(_velocity, Vector2.UP, true)


func set_gravity(delta):
	_velocity.y += GRAVITY * delta
	_velocity = move_and_slide(_velocity, Vector2.UP, true)

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
	_velocity = move_and_slide(_velocity, Vector2.UP, true)

func set_knockback():
	if(_is_facing_right):
		_velocity = Vector2(-0.5,-1.5) * 500
	else:
		_velocity = Vector2(0.5,-1.5) * 500
	_velocity = move_and_slide(_velocity, Vector2.UP)

func stairway_found():
	state_machine.is_stairway_nearby = true


func _set_connections() -> void:
	playerFrontalHitBox.connect("body_entered", self, "_on_body_entered_front")
	playerBackHitBox.connect("body_entered", self, "_on_body_entered_back")



func enable_whip_collision_shape() -> void:
	whipCollisionShape.disabled = false

func disable_whip_collision_shape() -> void:
	whipCollisionShape.disabled = true
