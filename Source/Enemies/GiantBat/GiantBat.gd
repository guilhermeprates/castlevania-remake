class_name GiantBat
extends Boss

enum State { IDLE, FLYING, PREPARE_ATTACK, ATTACKING, DEAD }

const RADIUS: int = 100

var _time: int = 0
var _state = State.IDLE
var _y_direction: int = 1
var _last_player_position: Vector2 = Vector2.ZERO

onready var preparingAttackTimer: Timer = $PreparingAttackTimer
onready var attackTimer: Timer = $AttackTimer
onready var position2D: Position2D = $Position2D
onready var hitbox: Area2D = $Position2D/Hitbox
onready var hitboxCollisionShape2D: CollisionShape2D = $Position2D/Hitbox/CollisionShape2D
onready var animationPlayer: AnimationPlayer = $AnimationPlayer
onready var leftRayCast: RayCast2D = $LeftRayCast2D
onready var rightRayCast: RayCast2D = $RightRayCast2D
onready var topRayCast: RayCast2D = $TopRayCast2D
onready var bottomRayCast: RayCast2D = $BottomRayCast2D

func _ready() -> void:
	_experience = 3000
	_setup_connections()
	_setup_attack_timer()

func _physics_process(delta: float) -> void:
	_time = delta
	_check_first_move()
	_check_direction()
	match(_state):
		State.IDLE:
			_idle(delta)
		State.FLYING:
			_fliying(delta)
		State.PREPARE_ATTACK:
			_prepare_attack(delta)
		State.ATTACKING:
			_attack(delta)
		State.DEAD:
			_die(delta)

func _check_first_move():
	if _state == State.IDLE and boss_event_trigged:
		_update_state(State.FLYING)
#		attackTimer.start()

func _check_direction():
	if leftRayCast.is_colliding():
		var collider = leftRayCast.get_collider()
		if !collider.is_in_group("Player"):
			_move_direction = 1
			_update_state(State.FLYING)
	if rightRayCast.is_colliding():
		var collider = rightRayCast.get_collider()
		if !collider.is_in_group("Player"):
			_move_direction = -1
			_update_state(State.FLYING)
	if topRayCast.is_colliding():
		var collider = topRayCast.get_collider()
		if !collider.is_in_group("Player"):
			_y_direction = 1
	if bottomRayCast.is_colliding():
		var collider = bottomRayCast.get_collider()
		if !collider.is_in_group("Player"):
			_y_direction = -1
		

func _setup_attack_timer() -> void:
#	preparingAttackTimer.set_wait_time(4.0)
#	preparingAttackTimer.set_one_shot(false)
#	preparingAttackTimer.connect("timeout", self, "_update_state", [State.PREPARE_ATTACK])
	attackTimer.set_wait_time(6.0)
	attackTimer.set_one_shot(false)
	attackTimer.connect("timeout", self, "_update_state", [State.ATTACKING])

func _setup_connections() -> void:
	var _result = hitbox.connect("area_entered", self, "_on_area_entered")

func _update_state(state) -> void:
	if state == State.ATTACKING:
		attackTimer.stop()
	elif state == State.FLYING:
		attackTimer.start()
	else:
		attackTimer.stop()
	_state = state

func _idle(delta: float) -> void:
	animationPlayer.play("Idle")

func _prepare_attack(delta: float) -> void:
	if boss_event_trigged:
		print("PREPARE ATTACK")
		animationPlayer.play("Flying")
		_velocity = Vector2.ZERO
		_velocity = move_and_slide(_velocity, Vector2.UP)

func _attack(delta: float) -> void:
	if boss_event_trigged:
		print("ATTACK")
		animationPlayer.play("Flying")
		var direction = to_local(_player_node.global_position).normalized()
		_velocity += (SPEED * 1.5) * direction  * delta
		_velocity = move_and_slide(_velocity, Vector2.UP)

func _fliying(delta: float) -> void:
	if boss_event_trigged:
#		print("FLYING")
		animationPlayer.play("Flying")
		_velocity.y = (cos(_time * 5) * 100) * _y_direction
		_velocity.x = SPEED * _move_direction
		_velocity = move_and_slide(_velocity, Vector2.UP)

func _die(delta: float) -> void:
	if boss_event_trigged:
		hitboxCollisionShape2D.set_deferred("disable", true)
		yield(get_tree().create_timer(0.2), "timeout")
		animationPlayer.play("Death")
		emit_signal("on_kill_boss", position)
		yield(get_tree().create_timer(0.4), "timeout")
		Game.player_score += _experience
		queue_free()

func _look_for_player() -> void:
	if _player_node.position.x < position.x:
		position2D.scale.x = -1
		_move_direction = -1
	else:
		position2D.scale.x = 1
		_move_direction = 1
	_moving = distance_to_player() < target_distance

func _on_area_entered(area: Area2D) -> void:
	if _state != State.DEAD:
#		if area.is_in_group("Player") and _state != State.FLYING:
#			attackTimer.start()
		if area.is_in_group("Whip"):
			health_points -= 1
			Game.boss_health_points = health_points
			if health_points == 0:
				_update_state(State.DEAD)
