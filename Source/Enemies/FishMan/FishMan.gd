class_name FishMan
extends Enemy

export (int, 1000, 10000) var attack_speed: int = 1000
export (float, 0, 10) var attack_rate: float = 5.0

var _jump: bool = true
var _can_attack: bool = false

onready var attackTimer: Timer = $AttackTimer
onready var collisionShape: CollisionShape2D = $CollisionShape2D
onready var position2D: Position2D = $Position2D
onready var hitbox: Area2D = $Position2D/Hitbox
onready var hitboxCollisionShape2D: CollisionShape2D = $Position2D/Hitbox/CollisionShape2D
onready var animationPlayer: AnimationPlayer = $AnimationPlayer
onready var atackOriginPoint: Node2D = $Position2D/AttackOriginPoint
onready var projectile = preload("res://Source/Projectile/Projectile.tscn")

func _ready() -> void:
	_experience = 300
	animationPlayer.play("Walk")
	var _result = hitbox.connect("area_entered", self, "_on_area_entered")

func _physics_process(delta: float) -> void:
	if not _dead: 
		if not _moving:
			_look_for_player()
		else:
			if _jump:
				_jump()
			if !_can_attack:
				_move(delta)
			else:
				_attack()
	
func _move(delta: float) -> void:
	if is_on_floor():
		_velocity.x = SPEED * _move_direction
	_velocity.y += GRAVITY * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)

func _jump() -> void:
	_jump = false
	_can_attack = true
	_velocity.y += -1300
	_velocity = move_and_slide(_velocity, Vector2.UP)

func _attack() -> void:
	if not _dead and _can_attack:
		var projectile_instance = projectile.instance()
		projectile_instance.position = atackOriginPoint.global_position
		print(_move_direction)
		projectile_instance.direction = _move_direction
		get_tree().get_root().add_child(projectile_instance)
		_can_attack = false
		animationPlayer.play("Attack")
		attackTimer.start(0.3) 
		yield(attackTimer, "timeout")
		animationPlayer.play("Walk")
		attackTimer.start(attack_rate) 
		yield(attackTimer, "timeout")
		_can_attack = true

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
		Game.player_score += _experience
		_dead = true
		hitboxCollisionShape2D.set_deferred("disable", true)
		yield(get_tree().create_timer(0.2), "timeout")
		animationPlayer.play("Death")
		emit_signal("on_kill_enemy", position)
		yield(get_tree().create_timer(0.4), "timeout")
		queue_free()
