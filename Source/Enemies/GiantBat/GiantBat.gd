class_name GiantBat
extends Boss

var _time: int = 0
var _trigged: bool = false
var _attack_trigged: bool = false

onready var timer: Timer = $Timer
onready var position2D: Position2D = $Position2D
onready var hitbox: Area2D = $Position2D/Hitbox
onready var hitboxCollisionShape2D: CollisionShape2D = $Position2D/Hitbox/CollisionShape2D
onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_experience = 3000
	var _result = hitbox.connect("area_entered", self, "_on_area_entered")
	animationPlayer.play("Idle") 
	timer.set_wait_time(3.0)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "_trigger_attack")
	timer.start() 

func _physics_process(delta: float) -> void:
	_time = delta
	if boss_event_trigged and !_trigged:
		animationPlayer.play("Flying") 
	if not _dead and boss_event_trigged:
		_trigged = true
		_look_for_player()
		if _attack_trigged:
			_attack(delta)
		else:
			_retreat(delta)

func _trigger_attack() -> void:
	_attack_trigged = true

func _attack(delta: float) -> void:
	pass

func _retreat(delta: float) -> void:
	var target_position = _player_node.position
	var direction_to_target = target_position - position
	var distance_to_target = direction_to_target.length()
	if distance_to_target < 200:
		print(distance_to_target)
		_velocity.x -= 10
		_velocity = move_and_slide(_velocity, Vector2.UP)
		

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
			Game.player_score += _experience
			_dead = true
			hitboxCollisionShape2D.set_deferred("disable", true)
			yield(get_tree().create_timer(0.2), "timeout")
			animationPlayer.play("Death")
			emit_signal("on_kill_boss", position)
			yield(get_tree().create_timer(0.4), "timeout")
			queue_free()
