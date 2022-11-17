class_name GiantBat
extends Boss

enum State { IDLE, FLYING, ATTACKING, DEAD }

const RADIUS = 250

var _time: int = 0
var _state = State.IDLE

onready var attackTimer: Timer = $AttackTimer
onready var position2D: Position2D = $Position2D
onready var hitbox: Area2D = $Position2D/Hitbox
onready var hitboxCollisionShape2D: CollisionShape2D = $Position2D/Hitbox/CollisionShape2D
onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_experience = 3000
	_setup_connections()
	_setup_attack_timer()

func _physics_process(delta: float) -> void:
	_time = delta 
	match(_state):
		State.IDLE:
			_idle(delta)
		State.FLYING:
			_fliying(delta)
		State.ATTACKING:
			_attack(delta)
		State.DEAD:
			_die(delta)

func _setup_attack_timer() -> void:
	attackTimer.set_wait_time(3.0)
	attackTimer.set_one_shot(false)
	attackTimer.connect("timeout", self, "_update_state", [State.ATTACKING])
	attackTimer.start()

func _setup_connections() -> void:
	var _result = hitbox.connect("area_entered", self, "_on_area_entered")

func _update_state(state) -> void:
	_state = state

func _idle(delta: float) -> void:
	print("STATE IDLE")
	animationPlayer.play("Idle")

func _attack(delta: float) -> void:
	if boss_event_trigged:
		print("STATE ATTACK")
		_look_for_player()
		animationPlayer.play("Flying") 
#		_velocity = Vector2(
#			sin(_time * SPEED) * RADIUS,
#			cos(_time * SPEED) * RADIUS
#		) + Vector2(250, 250)
#		move_and_slide(_velocity, Vector2.UP)

func _fliying(delta: float) -> void:
	if boss_event_trigged:
		print("STATE FLYING")
		animationPlayer.play("Flying")
	
func _die(delta: float) -> void:
	if boss_event_trigged:
		print("STATE DEAD")
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
	if area.is_in_group("Whip") and not _dead:
		health_points =- 1
		Game.boss_health_points = health_points
		if health_points == 0:
			_update_state(State.DEAD)
